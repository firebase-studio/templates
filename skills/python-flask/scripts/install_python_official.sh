#!/bin/bash
#
# Installs the Python Flask starter project.
# This script is self-sufficient and handles its own dependencies using Nix.
# It can be run with arguments or in interactive mode.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Argument Parsing & Interactive Mode ---
if [ -z "$1" ]; then
  # --- INTERACTIVE MODE ---
  # This block runs if the script is executed without any arguments.
  echo " Entering interactive mode to create a new Python Flask project..."

  # 1. Get Project Name from user input, with a default value.
  read -p "Enter project name (default: my-flask-project): " USER_PROJECT_DIR
  PROJECT_DIR=${USER_PROJECT_DIR:-my-flask-project}
  echo " Project will be created in: '${PROJECT_DIR}'"


  # 2. Present a menu to select the Package Manager.
  echo " Select a package manager:"
  select choice in "pip (standard Python)" "poetry (modern dependency management)"; do
    case $REPLY in
      1) PACKAGE_MANAGER="pip"; break;;
      2) PACKAGE_MANAGER="poetry"; break;;
      *) echo "Invalid option. Please select 1 or 2.";;
    esac
  done

  # 3. Present a menu to select the Application Type.
  echo "  Select an application type:"
  select choice in "web (Flask with a frontend)" "api (Flask for a JSON API)"; do
    case $REPLY in
      1) APP_TYPE="web"; break;;
      2) APP_TYPE="api"; break;;
      *) echo "Invalid option. Please select 1 or 2.";;
    esac
  done

else
  # --- NON-INTERACTIVE (AGENT) MODE ---
  # This block runs if arguments are provided.
  PROJECT_DIR="$1"
  PACKAGE_MANAGER="$2"
  APP_TYPE="$3"

  # Validation for non-interactive mode.
  if [ -z "$PROJECT_DIR" ] || [ -z "$PACKAGE_MANAGER" ] || [ -z "$APP_TYPE" ]; then
    echo "Usage: $0 <project-directory> <pip|poetry> <web|api>"
    echo "Or run without arguments for interactive mode: $0"
    exit 1
  fi
fi

# --- Script Body (remains unchanged) ---

echo " Creating a new Python Flask project in '${PROJECT_DIR}'..."

# 1. Copy source files.
echo " Copying template files for ${PACKAGE_MANAGER}/${APP_TYPE}..."
SOURCE_PATH="python-flask/${PACKAGE_MANAGER}/${APP_TYPE}"
cp -rf "${SOURCE_PATH}" "${PROJECT_DIR}"

# 2. Adjust permissions.
echo " Setting file permissions..."
chmod -R +w "${PROJECT_DIR}"
chmod +x "${PROJECT_DIR}/devserver.sh"

# 3. Generate Nix configuration.
echo " Generating Nix environment configuration..."
mkdir -p "${PROJECT_DIR}/.idx"

nix-shell -p j2cli nixfmt --run "
  packageManager=${PACKAGE_MANAGER} type=${APP_TYPE} j2 'python-flask/devNix.j2' -o '${PROJECT_DIR}/.idx/dev.nix'
  nixfmt '${PROJECT_DIR}/.idx/dev.nix'
"

# 4. Copy AI rules.
echo " Copying AI rules..."
cp -f "python-flask/.idx/airules.md" "${PROJECT_DIR}/.idx/airules.md"
cp -f "python-flask/.idx/airules.md" "${PROJECT_DIR}/GEMINI.md"

echo "Project setup complete! Your Flask app is ready in '${PROJECT_DIR}'."
