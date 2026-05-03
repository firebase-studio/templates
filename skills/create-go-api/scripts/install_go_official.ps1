# Installs the latest stable Go from official go.dev downloads (user-local install).
# - Detects CPU architecture
# - Fetches latest stable from https://go.dev/dl/?mode=json
# - Downloads the official ZIP
# - Extracts to %LOCALAPPDATA%\Programs\go\current
# - Adds %LOCALAPPDATA%\Programs\go\current\bin to user PATH (no admin required)
# - Prompts to restart terminal / Antigravity

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$MinGoVersion = if ($env:MIN_GO_VERSION) { $env:MIN_GO_VERSION } else { "1.20.0" }

function Get-GoVersion {
  try {
    $out = & go version 2>$null
    # "go version go1.22.5 windows/amd64"
    $tok = $out.Split(" ")[2]
    return $tok.Replace("go","")  # "1.22.5"
  } catch {
    return $null
  }
}

function Version-ToInt([string]$v) {
  # "1.22.5" -> comparable int
  $m = [regex]::Match($v, '^(\d+)\.(\d+)(?:\.(\d+))?$')
  if (-not $m.Success) { return 0 }
  $a = [int]$m.Groups[1].Value
  $b = [int]$m.Groups[2].Value
  $c = if ($m.Groups[3].Success) { [int]$m.Groups[3].Value } else { 0 }
  return ($a * 1000000) + ($b * 1000) + $c
}

function Get-LatestStableGoVersionTag {
  $data = Invoke-RestMethod -Uri "https://go.dev/dl/?mode=json"
  $stable = $data | Where-Object { $_.stable -eq $true } | Select-Object -First 1
  if (-not $stable -or -not $stable.version) {
    throw "Could not determine latest stable Go version from https://go.dev/dl/?mode=json"
  }
  return $stable.version  # e.g., "go1.22.5"
}

function Get-WindowsArchSuffix {
  $arch = $env:PROCESSOR_ARCHITECTURE
  switch ($arch) {
    "AMD64" { return "windows-amd64" }
    "ARM64" { return "windows-arm64" }
    default { throw "Unsupported Windows architecture: $arch" }
  }
}

# If Go already installed and >= MinGoVersion, do nothing.
$existing = Get-GoVersion
if ($existing) {
  if ((Version-ToInt $existing) -ge (Version-ToInt $MinGoVersion)) {
    Write-Host "Go is already installed (go$existing). No action needed."
    exit 0
  }
  Write-Host "Go detected (go$existing) but < $MinGoVersion; proceeding to install latest stable."
}

$versionTag = Get-LatestStableGoVersionTag   # "go1.22.5"
$platform   = Get-WindowsArchSuffix          # "windows-amd64"
$zipName    = "$versionTag.$platform.zip"    # "go1.22.5.windows-amd64.zip"
$zipUrl     = "https://go.dev/dl/$zipName"

$installBase = Join-Path $env:LOCALAPPDATA "Programs\go"
$installDir  = Join-Path $installBase "current"
$goBin       = Join-Path $installDir "bin"

New-Item -ItemType Directory -Force -Path $installBase | Out-Null

$tmpDir = Join-Path $env:TEMP ("go-install-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null

$zipPath = Join-Path $tmpDir $zipName
$extractDir = Join-Path $tmpDir "extract"
New-Item -ItemType Directory -Force -Path $extractDir | Out-Null

try {
  Write-Host "Downloading $zipUrl"
  Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

  Write-Host "Extracting ZIP"
  Expand-Archive -Path $zipPath -DestinationPath $extractDir -Force

  $extractedGoRoot = Join-Path $extractDir "go"
  if (-not (Test-Path $extractedGoRoot)) {
    throw "Extraction failed; expected folder not found: $extractedGoRoot"
  }

  # Install into ...\Programs\go\current (replace if exists)
  if (Test-Path $installDir) {
    Remove-Item -Recurse -Force $installDir
  }
  Move-Item -Path $extractedGoRoot -Destination $installDir

  # Add to user PATH if not present
  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  if (-not $userPath) { $userPath = "" }

  $already = $userPath.Split(";") | Where-Object { $_.Trim() -ieq $goBin }
  if (-not $already) {
    $newUserPath = ($goBin + ";" + $userPath).TrimEnd(";")
    [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
    Write-Host "Added Go to user PATH: $goBin"
  } else {
    Write-Host "Go bin path already present in user PATH."
  }

  # Also update current session PATH
  $env:Path = $goBin + ";" + $env:Path

  Write-Host "Installed Go ($versionTag) into $installDir"
  Write-Host "Verify:"
  & go version

  Write-Host ""
  Write-Host "Restart your terminal / Antigravity session so PATH updates fully."
} finally {
  if (Test-Path $tmpDir) { Remove-Item -Recurse -Force $tmpDir }
}