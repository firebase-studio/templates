# Installs the ADK from official sources for Windows (user-local install).
# - Detects if Python 3 is available via py.exe launcher.
# - Creates a self-contained Python virtual environment in ./.venv
# - Installs the latest stable google-adk and uvicorn from PyPI.
# - Prompts user with next steps to activate the environment.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$MinPythonMajor = 3
$MinPythonMinor = 9

# --- Helper Functions ---

function Get-PythonVersion {
    try {
        # Use the Python Launcher to find the best python version
        $out = py -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor})") 2>$null
        return $out
    } catch {
        return $null
    }
}

# --- Main Execution ---

Write-Host "Setting up ADK Python environment for Windows..."

$pyVersion = Get-PythonVersion
if (-not $pyVersion) {
    Write-Host "Error: Python 3 is not installed or not available via the 'py.exe' launcher."
    Write-Host "Please install Python $($MinPythonMajor).$($MinPythonMinor) or higher from https://python.org/downloads/windows/"
    exit 1
}

$pyMajor = [int]$pyVersion.Split(".")[0]
$pyMinor = [int]$pyVersion.Split(".")[1]

if (($pyMajor -lt $MinPythonMajor) -or ($pyMajor -eq $MinPythonMajor -and $pyMinor -lt $MinPythonMinor)) {
    Write-Host "Error: Your Python version is $($pyMajor).$($pyMinor). The ADK requires Python $($MinPythonMajor).$($MinPythonMinor) or higher."
    exit 1
}

Write-Host "Python $($pyVersion) detected. ✓"


$venvDir = ".\.venv"
if (Test-Path $venvDir) {
    Write-Host "Virtual environment '.venv' already exists. Skipping creation."
} else {
    Write-Host "Creating Python virtual environment in .\.venv ..."
    py -m venv $venvDir
}

Write-Host "Installing/updating ADK dependencies from PyPI..."

# Activate and install in one go
& "$($venvDir)\Scripts\python.exe" -m pip install --upgrade pip, google-adk, uvicorn

# --- Final Confirmation and Instructions ---

Write-Host ""
Write-Host "✅ Successfully set up the ADK environment."
Write-Host ""
Write-Host "To activate this environment and start working, run:"
Write-Host ""
Write-Host "  .\.venv\Scripts\Activate.ps1"
Write-Host ""
Write-Host "Once activated, you can:"
Write-Host " - Run your ADK agent (e.g., 'python main.py')"
Write-Host " - Use the 'adk' command-line tool."
Write-Host ""
Write-Host "To deactivate the environment when you are finished, simply run:"
Write-Host ""
Write-Host "  deactivate"
Write-Host ""
