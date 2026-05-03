# Django Workspace Setup Instructions

Follow these steps to initialize the workspace.

---

## 1. Install prerequisites (Python + pip)

This skill requires:
- Python (recommended 3.8+)
- pip (usually bundled with Python)

### 1.1 Verify Installation

Run the following commands to check if the prerequisites are installed:
- `python --version`
- `pip --version`

If both commands work, you can proceed to **Step 2**.

### 1.2 Install Python

If Python is not installed, download it from the official website: [python.org](https://www.python.org/downloads/) or install it via your operating system's package manager.

---

## 2. Create the Django Project

This step uses a setup script to scaffold the new project, create an isolated virtual environment, and install Django.

First, choose a name for your workspace:
`PROJECT_NAME="my-django-app"`

Then, run ONE of the following commands depending on your operating system:

#### Windows (PowerShell)
```powershell
powershell -ExecutionPolicy Bypass -File "skills/python-django/scripts/install_django.ps1" -ProjectName "$PROJECT_NAME"
```

#### macOS / Linux (bash)
```bash
bash "skills/python-django/scripts/install_django.sh" "$PROJECT_NAME"
```

This single command handles the entire project and dependency setup.

---

## 3. Configure Agents Rules

The setup script from the previous step has already configured the workspace for AI-assisted development by creating the following files inside your new project directory:
- `.idx/airules.md`
- `GEMINI.md`

No manual action is required for this step.

---

## 4. Run the Development Server

Once the project is created, navigate into the new directory and start the server.

```bash
cd "$PROJECT_NAME"
```

Then, run the appropriate command for your OS:

#### Windows
```bat
devserver.bat
```

#### macOS / Linux
```bash
./devserver.sh
```
