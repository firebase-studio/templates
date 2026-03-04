# PowerShell script to install PHP, Composer, and Node.js on Windows using Chocolatey.

# Ensure the script is run as an administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Warning "This script must be run as Administrator. Please right-click the script and select 'Run as Administrator'."
  Read-Host -Prompt "Press Enter to exit"
  exit 1
}

# Set execution policy for the current process
Set-ExecutionPolicy Bypass -Scope Process -Force

# --- Install Chocolatey ---
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey not found. Installing Chocolatey..."
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed."
}

# --- Install PHP ---
Write-Host "Installing PHP 8.1..."
choco install php --version=8.1 -y

# --- Install Composer ---
Write-Host "Installing Composer..."
# Set up Composer
$composerInstaller = 'composer-setup.php'
Invoke-WebRequest -Uri 'https://getcomposer.org/installer' -OutFile $composerInstaller
php $composerInstaller --install-dir="C:\ProgramData\ComposerSetup" --filename=composer
Remove-Item $composerInstaller
# Add Composer to the system PATH
$composerPath = 'C:\ProgramData\ComposerSetup'
$currentPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
if ($currentPath -notlike "*$composerPath*") {
    [System.Environment]::SetEnvironmentVariable('Path', "$currentPath;$composerPath", [System.EnvironmentVariableTarget]::Machine)
    $env:Path += ";$composerPath" # Update for current session
}


# --- Install Node.js ---
Write-Host "Installing Node.js (LTS)..."
choco install nodejs-lts -y


# --- Verification ---
Write-Host "--- Installation Complete ---"
Write-Host "Please restart your terminal or command prompt for all changes to take effect."
Write-Host "You can verify the installations by running the following commands in a NEW terminal:"
Write-Host "  php -v"
Write-Host "  composer --version"
Write-Host "  node -v"
Write-Host "  npm -v"

Read-Host -Prompt "Press Enter to continue"
