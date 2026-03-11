# This script verifies that Docker and Docker Compose are installed,
# as they are required to build and run this project.
# It does NOT install them automatically, as Docker installation is complex
# and requires user intervention.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "Checking for Docker..."

$docker_exists = Get-Command docker -ErrorAction SilentlyContinue
if (-not $docker_exists) {
    Write-Error "Error: 'docker' command not found."
    Write-Host "Docker is required to build and run this C++ project."
    Write-Host "Please install Docker Desktop for Windows by following the official instructions:"
    Write-Host "https://docs.docker.com/desktop/install/windows-install/"
    Write-Host "After installation, please restart your terminal or PowerShell session and try again."
    exit 1
}

$docker_version = (docker --version).Trim()
Write-Host "Docker found: $docker_version"

Write-Host "Checking for Docker Compose..."

$compose_v1_exists = Get-Command docker-compose -ErrorAction SilentlyContinue
$compose_v2_works = $false
try {
    docker compose version | Out-Null
    $compose_v2_works = $true
} catch {
    # docker compose is not a valid command, so v2 is not present
}

if ($compose_v1_exists) {
    $compose_version = (docker-compose --version).Trim()
    Write-Host "Docker Compose (v1) found: $compose_version"
} elseif ($compose_v2_works) {
    $compose_version = (docker compose version).Trim()
    Write-Host "Docker Compose (v2) found: $compose_version"
} else {
    Write-Error "Error: 'docker-compose' or 'docker compose' command not found."
    Write-Host "Docker Compose is required to run the application."
    Write-Host "It is included with Docker Desktop. If it's missing, please ensure your Docker Desktop installation is up to date."
    Write-Host "See: https://docs.docker.com/compose/install/"
    Write-Host "After installation, please restart your terminal or PowerShell session and try again."
    exit 1
}

Write-Host "All required dependencies (Docker, Docker Compose) are present."
exit 0
