# ADK Workspace Setup Instructions

Follow these steps to initialize and run a new ADK workspace.

## 1. Install prerequisites (Python)

This process requires Python 3.10 or newer.

### 1.1. Verify Python Installation

Run the following command in your terminal:

```bash
python3 --version
```

If the version is 3.10 or higher, you can continue to the next step. If not, you will need to install a newer version of Python.

### (Optional) 1.2. Automated Python Installation

If you need to install Python, you may use one of the provided scripts.

*   **For Windows (PowerShell):**

    ```powershell
    powershell -ExecutionPolicy Bypass -File "scripts/install_adk_official.ps1"
    ```

*   **For macOS & Linux (bash):**

    ```bash
    bash "scripts/install_adk_official.sh"
    ```

After running the script, restart your terminal and verify the installation.

---

## 2. Create the ADK Project

**Note:** The skill you are currently using handles this step automatically. It creates a new project directory with the name you provided.

---

## 3. Copy Project Files

The `create-adk` skill will copy the following files and directories from the skill's repository into your new workspace:

*   `main.py`
*   `requirements.txt`
*   `devserver.sh`
*   `agents/` (directory)
*   `tools/` (directory)
*   `.idx/airules.md` (copied from `resources/airules.md`)

---

## 4. Set Up Your Environment and Install Dependencies

After the skill has finished, navigate into your new project directory, create a virtual environment, and install the required dependencies.

```bash
# Replace <your_workspace_name> with the actual name of your project folder
cd "<your_workspace_name>"

# Create and activate a virtual environment
python3 -m venv .venv
source .venv/bin/activate
# (On Windows, use: .\.venv\Scripts\activate)

# Install dependencies from the requirements file
pip install -r requirements.txt
```

---

## 5. Run the Development Server

Use the `devserver.sh` script to start your ADK agents.

```bash
bash devserver.sh
```

Your ADK agents is now running and ready for development.

**Open the application in your browser:**
    The application will be available at [http://localhost:8000](http://localhost:8000).
