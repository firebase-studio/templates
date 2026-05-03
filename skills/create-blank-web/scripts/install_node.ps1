# Installs Node.js and npm for Windows using nvm-windows.
# - Downloads and runs the official nvm-windows installation script.
# - Installs the latest Long-Term Support (LTS) version of Node.js.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$MinNodeVersion = if ($env:MIN_NODE_VERSION) { $env:MIN_NODE_VERSION } else { "18.0.0" }

function Get-NodeVersion {
    try {
        $out = node --version 2>$null
        return $out.Trim().SubString(1) # "v18.12.1" -> "18.12.1"
    } catch {
        return $null
    }
}

function Version-ToInt([string]$v) {
    $parts = $v.Split(".")
    $major = if ($parts.Length -ge 1) { [int]$parts[0] } else { 0 }
    $minor = if ($parts.Length -ge 2) { [int]$parts[1] } else { 0 }
    $patch = if ($parts.Length -ge 3) { [int]$parts[2] } else { 0 }
    return ($major * 1000000) + ($minor * 1000) + $patch
}

# 1. Check if Node.js is already installed and meets the minimum version
$existingVersion = Get-NodeVersion
if ($existingVersion) {
    if ((Version-ToInt $existingVersion) -ge (Version-ToInt $MinNodeVersion)) {
        Write-Host "Node.js is already installed (version v$existingVersion >= v$MinNodeVersion). No action needed."
        exit 0
    } else {
        Write-Host "Node.js is installed (version v$existingVersion) but is less than the required version v$MinNodeVersion."
    }
}

# 2. Install nvm-windows if it's not already installed
$nvmDir = "$env:APPDATA\nvm"
if (-not (Test-Path "$nvmDir\nvm.exe")) {
    Write-Host "nvm-windows not found. Installing nvm-windows..."
    $nvmInstallerUrl = "https://github.com/coreybutler/nvm-windows/releases/latest/download/nvm-setup.zip"
    $nvmInstallerZip = "$env:TEMP\nvm-setup.zip"

    try {
        Invoke-WebRequest -Uri $nvmInstallerUrl -OutFile $nvmInstallerZip
        Expand-Archive -Path $nvmInstallerZip -DestinationPath "$env:TEMP\nvm-installer" -Force
        # Run the installer silently
        Start-Process -FilePath "$env:TEMP\nvm-installer\nvm-setup.exe" -ArgumentList '/S' -Wait
        Write-Host "nvm-windows installed. Please restart your terminal."
    } finally {
        Remove-Item $nvmInstallerZip -ErrorAction SilentlyContinue
        Remove-Item "$env:TEMP\nvm-installer" -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Host "Please restart your terminal session and run this script again to install Node.js."
    exit 1
} else {
    Write-Host "nvm-windows is already installed."
}

# 3. Reload environment variables and install Node.js
# In PowerShell, nvm is a command, not a function to be sourced.
Write-Host "Installing the latest LTS version of Node.js..."
try {
    nvm install lts
    nvm use lts
} catch {
    Write-Host "NVM command failed. It might be because nvm was just installed."
    Write-Host "Please restart your terminal session and run 'nvm install lts' manually."
    exit 1
}

# 4. Verify installation
Write-Host ""
Write-Host "Node.js installation complete."
Write-Host "Installed version:"
node --version
npm --version
Write-Host ""
Write-Host "Please restart your terminal session for the changes to take full effect."
