# Function to check if a command exists
function Command-Exists($command) {
    return Get-Command $command -ErrorAction SilentlyContinue
}

# Check for Node.js and npm
if (-not (Command-Exists "node") -or -not (Command-Exists "npm")) {
    Write-Host "Node.js and/or npm are not installed. Please install them to continue."
    
    # Attempt to install Node.js using Chocolatey
    if (Command-Exists "choco") {
        Write-Host "Attempting to install Node.js using Chocolatey..."
        choco install nodejs --yes
    } else {
        Write-Host "Chocolatey is not installed. Please visit https://chocolatey.org/ to install it, then rerun this script."
        Write-Host "Alternatively, you can download and install Node.js manually from https://nodejs.org/"
        exit 1
    }
}

# Verify installation
if ((Command-Exists "node") -and (Command-Exists "npm")) {
    Write-Host "Node.js and npm are installed."
    node -v
    npm -v
} else {
    Write-Host "Installation failed. Please install Node.js and npm manually."
    exit 1
}
