# Installs the latest .NET 8 SDK from official releases (user-local install).
# - Checks if .NET 8+ is already installed.
# - Downloads official installer script.
# - Installs to %USERPROFILE%\.dotnet_sdk
# - Adds to user PATH (no admin required)
# - Prompts to restart terminal / Antigravity

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Get-MajorVersion([string]$v) {
  $v = $v.Trim()
  return [int]($v.Split(".")[0])
}

# If .NET SDK already installed and >= 8, do nothing.
try {
  $existing = & dotnet --version 2>$null
  if ($LASTEXITCODE -eq 0) {
    $major = Get-MajorVersion $existing
    if ($major -ge 8) {
      Write-Host ".NET SDK is already installed ($existing). No action needed."
      exit 0
    }
    Write-Host ".NET SDK detected ($existing) but < 8; proceeding to install latest .NET 8 SDK."
  }
} catch {
  # dotnet not found
}

$InstallDir = Join-Path $env:USERPROFILE ".dotnet_sdk"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

$InstallScriptUrl = "https://dot.net/v1/dotnet-install.ps1"
$InstallScriptPath = Join-Path $InstallDir "dotnet-install.ps1"

Write-Host "Downloading dotnet-install.ps1 to $InstallScriptPath"
Invoke-WebRequest -Uri $InstallScriptUrl -OutFile $InstallScriptPath

Write-Host "Installing .NET 8 SDK to $InstallDir"
& $InstallScriptPath -Channel 8.0 -InstallDir $InstallDir -NoPath

# Add to user PATH if not present
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $userPath) { $userPath = "" }

$already = $userPath.Split(";") | Where-Object { $_.Trim() -ieq $InstallDir }
if (-not $already) {
  $newUserPath = ($InstallDir + ";" + $userPath).TrimEnd(";")
  [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
  Write-Host "Added .NET SDK to user PATH: $InstallDir"
} else {
  Write-Host ".NET SDK path already present in user PATH."
}

# Also update current session PATH
$env:Path = $InstallDir + ";" + $env:Path

Write-Host "Installed .NET 8 SDK"
Write-Host "Verify in this session:"
& dotnet --version

Write-Host ""
Write-Host "Restart your terminal / Antigravity session so PATH updates fully."
