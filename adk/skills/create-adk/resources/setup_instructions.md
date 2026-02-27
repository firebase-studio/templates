# ADK Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (Python + uv)

This skill requires:
- Python (recommended 3.11+)
- uv (a Python package installer from Astral)

### 1.1 Verify
Run:
- `python3 -V`
- `uv --version`

If both work, go to **Step 2**.

### 1.2 Install Python

**macOS / Linux (bash):**
Use your system's package manager (e.g., `brew install python` or `sudo apt-get install python3.11`) or download from the [official Python website](https://www.python.org/downloads/).

After installation, restart your terminal and verify with `python3 -V`.

### 1.3 Install uv

`uv` is used for fast dependency management.


**macOS / Linux (bash):**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

After installation, restart your terminal and verify with `uv --version`.

---

## 2. Create the Project Files

Set workspace name:
- `WS_NAME="<workspace_name>"`
- `mkdir "$WS_NAME"`

Create the following files inside the `$WS_NAME` directory:
- `requirements.txt` (list of Python dependencies)
- `devserver.sh` (script to run the dev server)
- A `.py` file for your main agent logic (e.g., `main.py`)


## 3. Install Dependencies

```bash
cd "$WS_NAME"

# Create a virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Install dependencies using uv
uv pip install -r requirements.txt
```

## 4. Configure Agent Rules

Create `.agent/rules/adk.md` inside the new workspace directory.

Copy the content from `resources/ai_rules.md`.

## 5. Run Server

```bash
# Ensure the devserver script is executable
chmod +x devserver.sh

# Run the development server
./devserver.sh
```
