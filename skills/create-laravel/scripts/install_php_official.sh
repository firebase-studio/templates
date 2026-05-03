#!/bin/bash

# This script installs PHP, Composer, and Node.js on Debian-based Linux distributions (like Ubuntu)
# and macOS using Homebrew.

# Function to detect the operating system
detect_os() {
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "macos"
    elif [[ -f /etc/lsb-release ]]; then
        echo "ubuntu"
    else
        echo "unsupported"
    fi
}

install_on_ubuntu() {
    echo "Updating package lists..."
    sudo apt-get update -y

    echo "Installing PHP and extensions..."
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt-get update -y
    sudo apt-get install -y php8.1 php8.1-cli php8.1-fpm php8.1-mbstring php8.1-xml php8.1-curl php8.1-zip unzip

    echo "Installing Composer..."
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d517431037fb1b0f82d8b58') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer

    echo "Installing Node.js and npm..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

install_on_macos() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "Updating Homebrew..."
    brew update

    echo "Installing PHP..."
    brew install php

    echo "Installing Composer..."
    brew install composer

    echo "Installing Node.js..."
    brew install node
}

OS=$(detect_os)

case $OS in
    "ubuntu")
        echo "Detected Ubuntu. Starting installation..."
        install_on_ubuntu
        ;;
    "macos")
        echo "Detected macOS. Starting installation..."
        install_on_macos
        ;;
    *)
        echo "Unsupported operating system. This script only supports Ubuntu and macOS."
        exit 1
        ;;
esac

echo "--- Installation Complete ---"
echo "Please restart your terminal session for changes to take effect."
echo "Verify installations by running:"
echo "php -v"
echo "composer --version"
echo "node -v"
echo "npm -v"

