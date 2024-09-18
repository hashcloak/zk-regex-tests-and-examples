use std::{fmt::Display, fs, io, path::Path, process::Command, string::FromUtf8Error};

use regex::Regex;

use crate::{constants, db::RegexInput};

#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error("error executing the generation command: {0:?}")]
    CommandExecutionFailed(io::Error),
    #[error("error reading the generated code from the Noir file: {0:?}")]
    FailedReadGeneratedCode(io::Error),
    #[error("error generating the code from the regex")]
    CodeGenerationFailed(String),
    #[error("error converting the output of the command to string")]
    IncorrectOutputConversion(FromUtf8Error),
}

pub struct Code {
    noir_code: String,
    input_size: usize,
    test_case: Option<String>,
}

impl Code {
    pub fn new(regex_input: &RegexInput) -> Result<Self, Error> {
        let noir_code = generate_noir_code(
            regex_input.regex.clone(),
            Path::new(constants::DEFAULT_GENERATION_PATH),
        )?;
        Ok(Self {
            noir_code,
            input_size: regex_input.input_size,
            test_case: None,
        })
    }

    pub fn set_test_case(&mut self, test_case: &str) {
        self.test_case = Some(String::from(test_case));
    }

    pub fn write_to_path(&self, path: &Path) {
        fs::write(path, self.to_string()).expect("the file should be written successfully");
    }
}

impl Display for Code {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match &self.test_case {
            Some(test_case) => {
                write!(
                    f,
                    "{}\nfn main(input: [u8; {}]) {{ regex_match(input); }}\n\n#[test]\nfn test() {{ let input = {:?}; regex_match(input); }}",
                    self.noir_code, self.input_size, test_case.as_bytes()
                )
            }
            None => {
                write!(
                    f,
                    "{}\nfn main(input: [u8; {}]) {{ regex_match(input); }}",
                    self.noir_code, self.input_size,
                )
            }
        }
    }
}

fn generate_noir_code(regex: Regex, result_path: &Path) -> Result<String, Error> {
    let output = Command::new("zk-regex")
        .args(["raw", "--raw-regex"])
        .arg(regex.as_str())
        .arg("--noir-file-path")
        .arg(result_path)
        .output()
        .map_err(Error::CommandExecutionFailed)?;

    if !output.status.success() {
        return Err(Error::CodeGenerationFailed(
            String::from_utf8(output.stderr).map_err(Error::IncorrectOutputConversion)?,
        ));
    }

    // Load code from stored file.
    let noir_generated_code =
        fs::read_to_string(result_path).map_err(Error::FailedReadGeneratedCode)?;

    Ok(noir_generated_code)
}
