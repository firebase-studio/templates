This skill helps you create a new agent project from the agent-garden template.

### Usage

To use this skill, follow these steps:

1.  **Create a new agent project:**
    ```bash
    --create-agent-garden <agent-name>
    ```
This skill helps you create a new agent project from the agent-garden template.

### Usage

To use this skill, follow these steps:

1.  **Prepare Environment:**
    The agent-garden template requires Node.js. Run the appropriate script to install it if it is not already on your system.

    - On Windows, run `scripts/install_node_official.ps1`.
    - On macOS/Linux, run `scripts/install_node_official.sh`.

2.  **Create a new agent project:**
    ```bash
    --create-agent-garden <agent-name>
    ```

3.  **Navigate to the new directory:**
    ```bash
    cd <agent-name>
    ```

4.  **Create the agents rules directory:**
    ```bash
    mkdir -p .agents/rules
    ```

5.  **Create the agents rules file:**
    ```bash
    touch .agents/rules/agent-garden.md
    ```
2.  **Navigate to the new directory:**
    ```bash
    cd <agent-name>
    ```

3.  **Create the agents rules directory:**
    ```bash
    mkdir -p .agents/rules
    ```

4.  **Create the agents rules file:**
    ```bash
    touch .agents/rules/agent-garden.md
    ```
