#!/bin/bash
# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Official Node.js installation script for Linux and macOS.
# Downloads and installs the latest LTS version of Node.js.

set -e # Exit on any error

# 1. Determine OS and architecture
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

NODE_MAJOR=20 # Specify the major version to install

# 2. Check for existing Node.js installation
if command -v node &> /dev/null; then
  CURRENT_VERSION=$(node -v | sed 's/v//' | cut -d '.' -f 1)
  if [ "$CURRENT_VERSION" -ge "$NODE_MAJOR" ]; then
    echo "Node.js version ${NODE_MAJOR}.x or higher is already installed."
    exit 0
  fi
fi

# 3. Construct the download URL
if [ "$OS" == "linux" ]; then
  if [ "$ARCH" == "x86_64" ]; then
    NODE_ARCH="x64"
  elif [ "$ARCH" == "aarch64" ]; then
    NODE_ARCH="arm64"
  else
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
  fi
  # Get the latest LTS version for the specified major version
  NODE_VERSION=$(curl -sL "https://nodejs.org/dist/index.json" | grep -A 5 '"version": "v'$NODE_MAJOR'"' | grep '"lts":' | head -1 | awk -F'"' 'NR==1 {print $4}' | sed 's/v//')
  DOWNLOAD_URL="https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz"
elif [ "$OS" == "darwin" ]; then # macOS
  NODE_VERSION=$(curl -sL "https://nodejs.org/dist/index.json" | grep -A 5 '"version": "v'$NODE_MAJOR'"' | grep '"lts":' | head -1 | awk -F'"' 'NR==1 {print $4}' | sed 's/v//')
  # For macOS, we can use the pkg installer
  DOWNLOAD_URL="https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.pkg"
else
  echo "Unsupported operating system: $OS" >&2
  exit 1
fi

# 4. Download and install
if [ "$OS" == "linux" ]; then
  echo "Downloading Node.js from ${DOWNLOAD_URL}..."
  curl -L "$DOWNLOAD_URL" -o "/tmp/node.tar.xz"
  
  INSTALL_DIR="$HOME/.nvm/versions/node/v${NODE_VERSION}"
  mkdir -p "$INSTALL_DIR"
  tar -xJf "/tmp/node.tar.xz" -C "$INSTALL_DIR" --strip-components=1
  
  # Add to PATH in shell profile
  PROFILE_FILE="$HOME/.bashrc"
  if [ -n "$ZSH_VERSION" ]; then
    PROFILE_FILE="$HOME/.zshrc"
  fi
  
  echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$PROFILE_FILE"
  echo "Node.js v${NODE_VERSION} has been installed."
  echo "Please restart your shell or run 'source $PROFILE_FILE' to apply changes."

elif [ "$OS" == "darwin" ]; then
  echo "Downloading Node.js package from ${DOWNLOAD_URL}..."
  curl -L "$DOWNLOAD_URL" -o "/tmp/node.pkg"
  
  echo "Running the installer... (You may be prompted for your password)"
  sudo installer -pkg "/tmp/node.pkg" -target /
  
  echo "Node.js v${NODE_VERSION} has been installed."
fi

# 5. Clean up
rm "/tmp/node.tar.xz" || rm "/tmp/node.pkg" || true
