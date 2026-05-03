This document provides instructions on how to set up and run the HTMX projects with either a Go or a Node.js backend.

### Go Backend

1.  **Navigate to the Go project directory:**

    ```bash
    cd htmx/go
    ```

2.  **Run the Go server:**

    ```bash
    go run main.go
    ```

3.  **Open the application in your browser:**

    The application will be available at [http://localhost:8080](http://localhost:8080).

4. **Configure Agents Rules:**

    Create the `.agents/rules/` directory and copy the AI rules into it:
    
    ```bash
    mkdir -p .agents/rules
    cp ../resources/ai_rules.md .agents/rules/htmx/go.md
    ```

### Node.js Backend

1.  **Navigate to the Node.js project directory:**

    ```bash
    cd htmx/node
    ```

2.  **Install the dependencies:**

    ```bash
    npm install
    ```

3.  **Run the Node.js server:**

    ```bash
    npm start
    ```

4.  **Open the application in your browser:**

    The application will be available at [http://localhost:3000](http://localhost:3000).

5. **Configure Agents Rules:**

    Create the `.agents/rules/` directory and copy the AI rules into it:
    
    ```bash
    mkdir -p .agents/rules
    cp ../resources/ai_rules.md .agents/rules/htmx/node.md
    ```
