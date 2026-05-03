#!/bin/bash

# Function to check if a command exists
command_exists () {
    command -v "$1" >/dev/null 2>&1
}

echo "Checking prerequisites for gemini-maps..."

# OS detection
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    MSYS*)      MACHINE=Windows;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

install_node() {
    echo "Node.js is not installed. Attempting to install on $MACHINE..."
    
    if [ "$MACHINE" == "Mac" ]; then
        if command_exists brew; then
            echo "Installing Node.js via Homebrew..."
            brew install node
        else
            echo "Homebrew not found. Please install Homebrew or install Node.js manually: https://nodejs.org/"
            exit 1
        fi
    elif [ "$MACHINE" == "Linux" ]; then
        if command_exists apt-get; then
            echo "Installing Node.js via apt-get..."
            sudo apt-get update
            sudo apt-get install -y nodejs npm
        elif command_exists yum; then
             echo "Installing Node.js via yum..."
             sudo yum install -y nodejs npm
        else
            echo "Supported package manager not found. Please install Node.js manually: https://nodejs.org/"
            exit 1
        fi
    elif [ "$MACHINE" == "Windows" ] || [ "$MACHINE" == "MinGw" ] || [ "$MACHINE" == "Cygwin" ]; then
        if command_exists winget; then
            echo "Installing Node.js via winget..."
            winget install -e --id OpenJS.NodeJS
        elif command_exists choco; then
            echo "Installing Node.js via Chocolatey..."
            choco install nodejs -y
        else
            echo "winget or chocolatey not found. Please download and install Node.js manually from: https://nodejs.org/"
            exit 1
        fi
    else
        echo "Unsupported operating system: $MACHINE"
        echo "Please install Node.js manually from: https://nodejs.org/"
        exit 1
    fi
}

# 1. Check Node.js
if command_exists node; then
    echo "Node.js is installed: $(node -v)"
else
    install_node
    # Refresh environment if necessary (though usually bash hash gets updated or requires opening a new terminal)
    hash -r
    
    if ! command_exists node; then
        echo "Node.js was installed, but 'node' command is not available in this session."
        echo "You may need to restart your terminal or run this script again."
        exit 0 # Exiting gracefully as they might just need a restart
    fi
fi

# 2. Check npm
if command_exists npm; then
    echo "npm is installed: $(npm -v)"
else
    echo "npm is not installed but node is. Please check your Node.js installation."
    exit 1
fi

echo "All prerequisites checked and installed!"
exit 0
