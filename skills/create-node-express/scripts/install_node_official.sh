#!/bin/bash

# Official script to install Node.js
# See: https://nodejs.org/en/download/package-manager

set -e

if ! command -v curl &> /dev/null
then
    echo "curl could not be found, please install it first."
    exit 1
fi

# For Debian/Ubuntu
if [ -f /etc/debian_version ]; then
    echo "Detected Debian/Ubuntu. Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs

# For Red Hat, CentOS, Fedora
elif [ -f /etc/redhat-release ]; then
    echo "Detected Red Hat/CentOS/Fedora. Installing Node.js..."
    sudo dnf install -y nodejs

# For macOS with Homebrew
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null
    then
        echo "Homebrew could not be found. Please install it first from https://brew.sh/"
        exit 1
    fi
    echo "Detected macOS. Installing Node.js with Homebrew..."
    brew install node

else
    echo "Unsupported operating system. Please install Node.js manually from https://nodejs.org/"
    exit 1
fi

echo "Node.js installation completed successfully."
