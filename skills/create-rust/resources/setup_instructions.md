# Create a Rust Project
    This guide will walk you through creating a new rust project and configuring your environment.

## 1. Prerequisites
    Before running the setup, ensure the environment has the following system packages available:
    - cargo
    
    *Action:* Run cargo -V to check the installed version. If cargo is not installed, install it or prompt the user to install it before proceeding.

## 2. Initialize Rust Project
    Create a new Rust project using Cargo.
    
    *Action:* Run the following command:
    ```bash
    cargo new "$workspace_name"
    ```
    
## 3. Configure Required Extensions
     Add the extensions: rust-lang.rust-analyzer, tamasfe.even-better-toml, serayuzgur.crates, vadimcn.vscode-lldb
     
## 4. Configure Agent Rules
    Create the `.agent/rules/rust.md` file using the content from `resources/airules.md`
