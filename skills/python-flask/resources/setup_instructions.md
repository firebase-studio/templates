# Python Flask Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (Python + pip/poetry)

This skill requires:
* Python (recommended 3.8+)
* pip (usually bundled with Python)
* Poetry (if selected as the package manager)

### 1.1 Verify

Run the following commands to check if the prerequisites are installed:

*   `python --version`
*   `pip --version`

If you plan to use `poetry`, also run:

*   `poetry --version`

If all required commands work, go to Step 2.

### 1.2 Install

**Python and pip:**

If you don't have Python and pip, please install them from the official Python website: [https://www.python.org/downloads/](https://www.python.org/downloads/)

**Poetry:**

If the `poetry --version` command failed and you wish to use it, install it by running:

`pip install poetry`

Then restart your terminal/Antigravity session and verify again.

## 2. Create the Flask Project

Use the main installation script to create your project.

Run the `install.sh` script with the chosen project name, package manager, and application type.

### Command

```bash
bash skills/python-flask/scripts/install.sh {{projectName}} {{packageManager}} {{type}}
```

### Example

To create a new web app named `my-flask-app` using `pip`:

```bash
bash skills/python-flask/scripts/install.sh my-flask-app pip web
```
