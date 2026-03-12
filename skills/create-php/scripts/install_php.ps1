# A script to install PHP on Windows

# Check if PHP is already installed
if (Get-Command php -ErrorAction SilentlyContinue) {
  Write-Host "PHP is already installed."
  exit 0
}

# Check if Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  Write-Error "Chocolatey is not installed. Please install it first from https://chocolatey.org/install"
  exit 1
}

# Install PHP
choco install -y php

Write-Host "PHP installed successfully."
