#!/usr/bin/env bash
#
# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Description: This script installs the latest version of Node.js and npm using nvm.
# It is intended to be run in a Linux or macOS environment.

set -e

# Function to print messages
info() {
    echo "[INFO] $1"
}

# 1. Install nvm (Node Version Manager)
if ! command -v nvm &> /dev/null; then
    info "nvm not found, installing..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
else
    info "nvm is already installed."
fi

# 2. Install the latest version of Node.js
info "Installing the latest version of Node.js..."
nvm install node

# 3. Verify the installation
info "Verifying Node.js and npm installation..."
node -v
npm -v

info "Node.js and npm have been successfully installed."
