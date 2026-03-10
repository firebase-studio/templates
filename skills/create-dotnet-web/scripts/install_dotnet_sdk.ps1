# Installs the latest stable .NET SDK from Microsoft's official source.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$MinVersion = "8.0.0"

function Get-InstalledDotNetVersion {
  try {
    $out = & dotnet --version 2>$null
    return $out.Trim()
  } catch {
    return $null
  }
}

function Version-ToInt([string]$v) {
  $parts = $v.Split('.')
  $major = if ($parts.Length -gt 0) { [int]$parts[0] } else { 0 }
  $minor = if ($parts.Length -gt 1) { [int]$parts[1] } else { 0 }
  $patch = if ($parts.Length -gt 2) { [int]$parts[2] } else { 0 }
  return ($major * 1000000) + ($minor * 1000) + $patch
}

# If .NET is already installed and meets the minimum version, do nothing.
$existing = Get-InstalledDotNetVersion
if ($existing) {
  if ((Version-ToInt $existing) -ge (Version-ToInt $MinVersion)) {
    Write-Host ".NET SDK is already installed (version $existing). No action needed."
    exit 0
  }
  Write-Host ".NET SDK detected (version $existing) but it is less than $MinVersion. Proceeding to install the latest stable version."
}

# Download and run the official installer script
$installScriptUrl = "https://dot.net/v1/dotnet-install.ps1"
$installScriptPath = Join-Path $env:TEMP "dotnet-install.ps1"

Invoke-WebRequest -Uri $installScriptUrl -OutFile $installScriptPath

# Run the installer to get the latest LTS version
& $installScriptPath -Channel LTS -InstallDir "$HOME/.dotnet"

# Add to user PATH if not present
$dotNetBin = Join-Path $HOME ".dotnet"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

if (-not $userPath.Contains($dotNetBin)) {
  $newUserPath = "$dotNetBin;" + $userPath
  [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
  Write-Host "Added .NET to user PATH: $dotNetBin"
  
  # Also update current session PATH
  $env:Path = "$dotNetBin;" + $env:Path
} else {
  Write-Host ".NET bin path already present in user PATH."
}

Write-Host "Installed .NET SDK."
Write-Host "Please restart your terminal or Antigravity session for the PATH changes to take full effect."
Write-Host "Verify by running: dotnet --version"
