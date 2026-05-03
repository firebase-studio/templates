# This script installs Java (OpenJDK 17) and Maven using Chocolatey for Windows.

# Check if Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey not found. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed."
}

# Check for Java
$java_ok = $false
try {
    $java_version = java -version 2>&1 | Select-String -Pattern "version"
    if ($java_version -like '*"17.*') {
        Write-Host "Java 17 is already installed ($java_version)."
        $java_ok = $true
    } else {
        Write-Host "An unsupported version of Java is installed ($java_version). Proceeding with installation of version 17."
    }
} catch {
    # Java not found
}

# Check for Maven
$maven_ok = $false
try {
    $maven_version = mvn -v 2>&1 | Select-String -Pattern "Apache Maven"
    Write-Host "Maven is already installed ($maven_version)."
    $maven_ok = $true
} catch {
    # Maven not found
}

if ($java_ok -and $maven_ok) {
    Write-Host "Java and Maven are already installed. No action needed."
    exit 0
}

# Install Java if not installed
if (-not $java_ok) {
    Write-Host "Installing Java 17..."
    choco install openjdk --version=17 -y
}

# Install Maven if not installed
if (-not $maven_ok) {
    Write-Host "Installing Maven..."
    choco install maven -y
}

Write-Host ""
Write-Host "Java and Maven installation complete."
Write-Host "Please restart your terminal / Antigravity session so PATH updates fully, then verify:"
Write-Host "  java -version"
Write-Host "  mvn -v"
