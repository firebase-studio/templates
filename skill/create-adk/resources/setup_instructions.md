This document provides instructions on how to set up and run the ADK application.

### 1. **Activate the environment and run the development server:**

This template includes a `devserver.sh` script that activates the environment and starts the ADK web server.

```bash
./devserver.sh
```

The application will be available in the Previews panel or at [http://localhost:8000](http://localhost:8000).

### 2. **Alternative: Run the ADK agent manually**

You can also run the agent manually after activating the virtual environment.

1.  **Activate the virtual environment:**
    ```bash
    source .venv/bin/activate
    ```
2.  **Run the agent's web interface:**
    ```bash
    adk web multi_tool_agent
    ```
3.  **Open the application in your browser:**
    The application will be available at [http://localhost:8000](http://localhost:8000).
