#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for Node.js and npm
if ! command_exists node || ! command_exists npm; then
    echo "Node.js and/or npm are not installed. Please install them to continue."
    # Attempt to install Node.js using package managers
    if command_exists apt-get; then
        echo "Attempting to install Node.js using apt-get..."
        sudo apt-get update
        sudo apt-get install -y nodejs npm
    elif command_exists yum; then
        echo "Attempting to install Node.js using yum..."
        sudo yum install -y nodejs npm
    elif command_exists brew; then
        echo "Attempting to install Node.js using Homebrew..."
        brew install node
    else
        echo "Could not find a package manager to install Node.js automatically."
        echo "Please visit https://nodejs.org/ to download and install Node.js."
        exit 1
    fi
fi

# Verify installation
if command_exists node && command_exists npm; then
    echo "Node.js and npm are installed."
    node -v
    npm -v
else
    echo "Installation failed. Please install Node.js and npm manually."
    exit 1
fi
