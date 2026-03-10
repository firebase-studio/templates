#!/bin/bash
# Installs the latest Node.js LTS from official nodejs.org releases (user-local install).
# - Detects OS and CPU architecture
# - Fetches latest LTS from Node dist index.json
# - Downloads the official tar.gz
# - Extracts to a user-writable location
# - Provides instructions to add to PATH

set -e # exit on error

# Function to get major version from string like "v20.11.1"
get_major_version() {
  echo "$1" | cut -d'v' -f2 | cut -d'.' -f1
}

# If Node already installed and >= 20, do nothing.
if command -v node &>/dev/null; then
  existing_version=$(node -v)
  major_version=$(get_major_version "$existing_version")
  if [ "$major_version" -ge 20 ]; then
    echo "Node is already installed ($existing_version)."
    echo -n "npm version: "
    npm -v
  else
    echo "Node detected ($existing_version) but < 20; proceeding to install latest LTS."
    # Get OS and architecture
    os_type=$(uname -s | tr '[:upper:]' '[:lower:]') # linux or darwin
    cpu_arch=$(uname -m)
    case "$cpu_arch" in
      x86_64 | amd64)
        node_arch="x64"
        ;;
      arm64 | aarch64)
        node_arch="arm64"
        ;;
      *)
        echo "Unsupported architecture: $cpu_arch"
        exit 1
        ;;
    esac

    # Get latest LTS version from nodejs.org
    echo "Fetching latest LTS version..."
    # Use grep/sed to avoid jq dependency
    lts_version=$(curl -s https://nodejs.org/dist/index.json | grep '"lts":' -B 1 | head -n 1 | sed -n 's/.*"version": "\(v[0-9.]*\)".*/\1/p')

    if [ -z "$lts_version" ]; then
      echo "Could not determine latest LTS from https://nodejs.org/dist/index.json"
      exit 1
    fi

    echo "Latest LTS is $lts_version"
    file_name="node-${lts_version}-${os_type}-${node_arch}.tar.gz"
    download_url="https://nodejs.org/dist/${lts_version}/${file_name}"

    # Install location
    install_dir="$HOME/.local/bin/node-${lts_version}"
    bin_dir="$install_dir/bin"
    mkdir -p "$install_dir"

    # Download and extract
    echo "Downloading $download_url"
    curl -L "$download_url" | tar -xz -C "$install_dir" --strip-components=1

    # Provide instructions to add to PATH
    echo ""
    echo "Node.js $lts_version has been installed to: $install_dir"
    echo ""
    echo "To use it, you need to add it to your PATH."
    echo "Run the following command:"
    echo ""
    echo "  export PATH=\"$bin_dir:\$PATH\""
    echo ""
    echo "To make this change permanent, add the line above to your shell profile"
    echo "(e.g., ~/.bashrc, ~/.zshrc, or ~/.profile) and restart your shell."
    echo ""
    echo "After restarting your shell, verify with:"
    echo "  node -v"
    echo "  npm -v"
  fi
fi

npm install
node index.js
