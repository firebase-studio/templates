#!/usr/bin/env bash
set -euo pipefail

# Installs Node.js and npm using Node Version Manager (nvm).
# - Downloads and runs the official nvm installation script.
# - Installs the latest Long-Term Support (LTS) version of Node.js.
# - Updates shell profile to load nvm.

MIN_NODE_VERSION="${MIN_NODE_VERSION:-18.0.0}"

need_cmd() { command -v "$1" >/dev/null 2>&1; }

ver_to_int() {
  # Converts a version string like "18.12.1" to a comparable integer.
  local IFS=.
  read -r a b c <<< "${1//v/}" # Strip 'v' prefix if present
  printf "%03d%03d%03d" "${a:-0}" "${b:-0}" "${c:-0}"
}

current_node_version() {
  node --version
}

# 1. Check if Node.js is already installed and meets the minimum version
if need_cmd node; then
  CUR_VERSION_STR="$(current_node_version)"
  if [[ "$(ver_to_int "$CUR_VERSION_STR")" -ge "$(ver_to_int "$MIN_NODE_VERSION")" ]]; then
    echo "Node.js is already installed (version $CUR_VERSION_STR >= $MIN_NODE_VERSION). No action needed."
    exit 0
  else
    echo "Node.js is installed (version $CUR_VERSION_STR) but is less than the required version $MIN_NODE_VERSION."
  fi
fi

# 2. Install nvm if it's not already installed
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  echo "nvm not found. Installing nvm..."
  if need_cmd curl; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  elif need_cmd wget; then
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  else
    echo "Error: You need curl or wget to install nvm."
    exit 1
  fi
  echo "nvm installed."
else
  echo "nvm is already installed."
fi

# Source nvm to make it available in the current script
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# 3. Install the latest LTS version of Node.js
echo "Installing the latest LTS version of Node.js..."
nvm install --lts

# 4. Verify installation
echo ""
echo "Node.js installation complete."
echo "Installed version:"
node --version
npm --version
echo ""
echo "Please restart your terminal session for the changes to take full effect."
