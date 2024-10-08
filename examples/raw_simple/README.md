# ZK-regex + Noir example

In this document, we will present an example of how to use the [zk-regex](https://github.com/zkemail/zk-regex) project to generate [Noir](https://noir-lang.org/) code that proves that an input string satisfies given public regex public regex.

## Requirements:

To follow this example, you should have the following tools installed in your system:
- zk-regex. To install this, follow the instructions in the [documentation](https://github.com/zkemail/zk-regex?tab=readme-ov-file#install).
- Noir. You can install this using the [installation instructions](https://noir-lang.org/docs/getting_started/installation/).

Note that this example has been generated using [this branch](https://github.com/hashcloak/noir-zk-regex/tree/features/hc_improvements) of zk-regex with Noir support. 

## Generating the Noir circuit automatically
Suppose you want to prove that an input string fulfills the regex `m(a|b)+-(c|d)+e` in your project. First, you need to create your project using the command
```
$ nargo new own_project
```
This will create a new Noir project inside the `own_project/` folder in which you will put all of your application functionality, including the circuit, in charge of checking if the input string fulfills the regex pattern.

Now, let us use the zk-regex project to generate the Noir code associated with the regex above. The zk-regex tool allows you to encode the provided regex into a lookup table that checks whether an input fulfills the regex. The tool will generate a piece of Noir code that you should include in your project to create the proof.

The first step is to generate the Noir code for the provided regex. To do this, we execute the following command
```bash
$ zk-regex raw --raw-regex "m(a|b)+-(c|d)+e" --noir-file-path "auto_code.nr"
```

Once the command is executed, it will generate the file `auto_code.nr`, which you can find in this example folder as well. 

This source code must be copied into your code for use. Let us say that you should include the generated source code in the `main.nr` file in your project. Then you need to copy the content from `auto_code.nr` into `own_project/src/main.nr`. Also, you will need to modify your `main.nr` file to receive the input string and evaluate the regex:

```rust
// ...code from auto_code.nr...

fn main(input: [u8; 16]) {
    regex_match(input);
}
``` 
Notice that we have called the function `regex_match()`, passing the input provided to the `main()` function.

We have finished incorporating the code, and you can use it in further functionalities. Let us add a test to check that the regex identifies the input string correctly. First, let us add a test where the input corresponds to the regex pattern:
```rust
#[test]
fn test_match() {
    // UTF-8 version of mababaaba-cdddce
    let input = [109, 097, 098, 097, 098, 097, 097, 098, 097, 045, 099, 100, 100, 100, 099, 101];
    regex_match(input);
}
```
This test should pass when we run the command `nargo test`. Also, let us consider a test in which the input string does not match the regex pattern:
```rust
#[test(should_fail)]
fn test_not_match() {
    // UTF-8 version of mabaababaab-cdfe
    let input = [109, 097, 098, 097, 097, 098, 097, 098, 097, 097, 098, 045, 099, 100, 102, 101];
    regex_match(input);
}
```
This last test will also pass when we run the command `nargo test`.