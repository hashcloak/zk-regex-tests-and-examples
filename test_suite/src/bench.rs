use std::{
    fmt::Display,
    fs,
    path::{Path, PathBuf},
    process::Command,
};

use anyhow::Context;
use serde::{Deserialize, Serialize};
use serde_json::Value;

use crate::{constants, BenchExecType};

/// Error that may happen in the command execution.
#[derive(thiserror::Error, Debug)]
pub enum Error<'a> {
    #[error("error executing the terminal command {0:?}: {1:?}")]
    CommandOutputError(&'a str, String),
    #[error("error in the database input: the input size differs from the length of the benchmarking string - input size: {0:?}, length of benchmarking string: {1:?}")]
    BadDbInput(usize, usize),
}

/// Results of the benchmark.
///
/// This results are extracted using the command `bb gates -b <target>`
#[derive(Deserialize, Serialize)]
pub struct BenchResult {
    /// Number of ACIR opcodes generated by the compiler.
    pub acir_opcodes: u32,
    /// The number of gates.
    pub circuit_size: u32,
    /// Number of gates per opcode.
    #[serde(skip_serializing)]
    pub gates_per_opcode: Vec<u32>,
    /// Regex
    #[serde(skip_deserializing)]
    pub regex: String,
    /// Tells if this benchmark was performed using the gen_substr() function.
    #[serde(skip_deserializing)]
    pub with_gen_substr: bool,
    /// Time spent in the proving.
    #[serde(skip_deserializing)]
    pub proving_time: f64,
    #[serde(skip_serializing, skip_deserializing)]
    pub with_time: bool,
}

impl Display for BenchResult {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        if self.with_time {
            write!(
                f,
                "ACIR opcodes: {}\nCircuit size: {}\nGates per opcode: {:?}\nAverage proving time [s]: {}\n",
                self.acir_opcodes, self.circuit_size, self.gates_per_opcode, self.proving_time
            )
        } else {
            write!(
                f,
                "ACIR opcodes: {}\nCircuit size: {}\nGates per opcode: {:?}\n",
                self.acir_opcodes, self.circuit_size, self.gates_per_opcode,
            )
        }
    }
}

/// Container for the benchmark results for each test.
#[derive(Serialize, Default)]
pub struct BenchReport(Vec<BenchResult>);

impl BenchReport {
    /// Adds a result to the report.
    pub fn push_result(&mut self, result: BenchResult) {
        self.0.push(result);
    }

    /// Save the report to a CSV file given by the path.
    pub fn save(self, path: &Path) -> anyhow::Result<()> {
        let mut writer = csv::Writer::from_path(path)?;
        for result in self.0 {
            writer.serialize(result)?;
        }
        Ok(())
    }

    /// Returns if the report has any benchmark result or not.
    pub fn is_empty(&self) -> bool {
        self.0.is_empty()
    }
}

/// Executes the command to count the gate. This command must be executed after
/// the code is successfully compiled. To count the number of gates, we use the
/// command `bb gates -b <target>`.
pub fn benchmark_noir_code(
    input_size: usize,
    benchmark_str: String,
    bench_exec_type: &BenchExecType,
) -> anyhow::Result<BenchResult> {
    // Count the gates and create the BenchResult. The gates can be counted always.
    let mut bench_result = count_gates()?;

    match bench_exec_type {
        BenchExecType::WithTime => {
            modify_prover_toml(input_size, benchmark_str)?;
            let avg_proving_time = execute_proving_time_command()?;
            bench_result.proving_time = avg_proving_time;
            bench_result.with_time = true;
        }
        BenchExecType::NoTime => {
            bench_result.with_time = false;
        }
    }

    Ok(bench_result)
}

/// Modifies the Prover.toml file to have the right input size to measure the proving time.
pub fn modify_prover_toml(input_size: usize, benchmark_str: String) -> anyhow::Result<()> {
    if input_size != benchmark_str.len() {
        anyhow::bail!(Error::BadDbInput(input_size, benchmark_str.len()));
    }

    // Fill the input element with a random vector with the respective input size.
    let contents_int = benchmark_str.chars().map(|c| c as u8).collect::<Vec<u8>>();
    let contents = format!("input = {:?}", contents_int);
    fs::write(constants::DEFAULT_PROVER_TOML_PATH, contents)?;
    Ok(())
}

/// Executes the command to count the number of gates.
pub fn count_gates() -> anyhow::Result<BenchResult> {
    let output = Command::new("bb")
        .args(["gates", "-b"])
        .arg(constants::DEFAULT_TARJET_JSON_FILE)
        .current_dir(constants::DEFAULT_PROJECT_PATH)
        .output()
        .context("the gate-count command was not executed correctly")?;
    if !output.status.success() {
        anyhow::bail!(Error::CommandOutputError(
            "bb gates",
            String::from_utf8(output.stderr)?
        ));
    }

    let str_result_json = String::from_utf8(output.stdout)?;
    let output_value: Value = serde_json::from_str(&str_result_json)?;

    let bench_result: BenchResult =
        serde_json::from_str(&output_value["functions"][0].to_string())?;

    Ok(bench_result)
}

/// Counts the number of seconds spent in the proving time as an average of
/// 3 executions. This average is computed using the `hyperfine` command.
pub fn execute_proving_time_command() -> anyhow::Result<f64> {
    // Generate the witness
    let output = Command::new("nargo")
        .args(["execute", constants::DEFAULT_WITNESS_NAME])
        .current_dir(constants::DEFAULT_PROJECT_PATH)
        .output()
        .context("error generating the witness while measuring the proving time")?;
    if !output.status.success() {
        anyhow::bail!(Error::CommandOutputError(
            "nargo execute",
            String::from_utf8(output.stderr)?
        ));
    }

    // Defines a path to the previous directory ".."
    let mut prev_path = PathBuf::from("..");

    // Creates the path ../<JSON_PATH>
    prev_path.push(Path::new(constants::DEFAULT_PROVING_TIME_RESULT_FILE));
    // It is safe to do unwrap because we are sure that the string is correct.
    let path_json_time_str = prev_path.as_path().to_str().unwrap();

    let output = Command::new("hyperfine")
        .args(["--export-json", path_json_time_str])
        .args(["--runs", "5"])
        .arg("--show-output")
        .args(["--time-unit", "millisecond"])
        .arg(format!(
            "bb prove -b {} -w {} -o {}",
            constants::DEFAULT_TARJET_JSON_FILE,
            constants::DEFAULT_WITNESS_PATH,
            constants::DEFAULT_PROOF_PATH
        ))
        .current_dir(constants::DEFAULT_PROJECT_PATH)
        .output()
        .context("error executing the proving time command")?;
    if !output.status.success() {
        anyhow::bail!(Error::CommandOutputError(
            "hyperfine",
            String::from_utf8(output.stderr)?
        ));
    }

    // Extract the results from the JSON file
    let result_json_str = fs::read_to_string(constants::DEFAULT_PROVING_TIME_RESULT_FILE)?;
    let value_result: Value = serde_json::from_str(&result_json_str)?;
    let avg_time = value_result["results"][0]["mean"]
        .as_f64()
        .context("the conversion was not done correctly")?;

    Ok(avg_time)
}
