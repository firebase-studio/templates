#!/bin/bash
# Installs the ADK from official sources for Linux & macOS (user-local install).
# - Detects if Python 3 is available.
# - Creates a self-contained Python virtual environment in ./.venv
# - Installs the latest stable google-adk and uvicorn from PyPI.
# - Prompts user with next steps to activate the environment.

set -e # Exit immediately if a command exits with a non-zero status.

MIN_PYTHON_MAJOR=3
MIN_PYTHON_MINOR=9

# --- Helper Functions ---

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to check Python version
check_python_version() {
  if ! command_exists python3; then
    echo "Error: Python 3 is not installed. Please install Python $MIN_PYTHON_MAJOR.$MIN_PYTHON_MINOR or higher."
    exit 1
  fi

  PY_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
  PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
  PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)

  if [ "$PY_MAJOR" -lt "$MIN_PYTHON_MAJOR" ] || { [ "$PY_MAJOR" -eq "$MIN_PYTHON_MAJOR" ] && [ "$PY_MINOR" -lt "$MIN_PYTHON_MINOR" ]; }; then
    echo "Error: Your Python version is $PY_MAJOR.$PY_MINOR. The ADK requires Python $MIN_PYTHON_MAJOR.$MIN_PYTHON_MINOR or higher."
    exit 1
  fi
  echo "Python $PY_VERSION detected. ✓"
}

# --- Main Execution ---

echo "Setting up ADK Python environment for Linux/macOS..."

check_python_version

# Check if virtual environment already exists
if [ -d ".venv" ]; then
  echo "Virtual environment '.venv' already exists. Skipping creation."
else
  echo "Creating Python virtual environment in ./.venv ..."
  python3 -m venv .venv
fi

# Use the python from the virtual env to install packages
echo "Installing/updating ADK dependencies from PyPI..."
./.venv/bin/python -m pip install --upgrade pip google-adk uvicorn > /dev/null

# --- Final Confirmation and Instructions ---

cat <<EOF

✅ Successfully set up the ADK environment.

To activate this environment and start working, run:

  source ./.venv/bin/activate

Once activated, you can:
 - Run your ADK agents (e.g., 'python main.py')
 - Use the 'adk' command-line tool.

To deactivate the environment when you are finished, simply run:

  deactivate

EOF
