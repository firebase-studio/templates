# Official script to install Node.js for Windows using Winget

#Requires -RunAsAdministrator

# Set execution policy to allow scripts to run
Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# Check if winget is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget is not installed or not in the PATH. Please install it from the Microsoft Store."
    exit 1
}

# Install the latest LTS version of Node.js
Write-Host "Installing Node.js LTS..."
winget install OpenJS.NodeJS.LTS

Write-Host "Node.js installation completed successfully."
