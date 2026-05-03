# Installs the latest Node.js LTS from official nodejs.org releases (user-local install).
# - Detects CPU architecture
# - Fetches latest LTS from Node dist index.json
# - Downloads the official ZIP
# - Extracts to %LOCALAPPDATA%\Programs\nodejs\<version>
# - Adds to user PATH (no admin required)
# - Prompts to restart terminal / Antigravity

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Get-LatestLtsVersion {
  $index = Invoke-RestMethod -Uri "https://nodejs.org/dist/index.json"
  $lts = $index | Where-Object { $_.lts -ne $false } | Select-Object -First 1
  if (-not $lts -or -not $lts.version) {
    throw "Could not determine latest LTS from https://nodejs.org/dist/index.json"
  }
  return $lts.version  # e.g., v20.11.1
}

function Get-PlatformSuffix {
  $arch = $env:PROCESSOR_ARCHITECTURE
  switch ($arch) {
    "AMD64" { return "win-x64" }
    "ARM64" { return "win-arm64" }
    "x86"   { return "win-x86" }
    default { throw "Unsupported Windows architecture: $arch" }
  }
}

function Get-MajorVersion([string]$v) {
  # v like "v20.11.1"
  $v = $v.Trim()
  if ($v.StartsWith("v")) { $v = $v.Substring(1) }
  return [int]($v.Split(".")[0])
}

# If Node already installed and >= 20, do nothing.
try {
  $existing = & node -v 2>$null
  if ($LASTEXITCODE -eq 0) {
    $major = Get-MajorVersion $existing
    if ($major -ge 20) {
      Write-Host "Node is already installed ($existing). No action needed."
      Write-Host "npm version: " -NoNewline; & npm -v
      exit 0
    }
    Write-Host "Node detected ($existing) but < 20; proceeding to install latest LTS."
  }
} catch {
  # node not found
}

$version  = Get-LatestLtsVersion
$platform = Get-PlatformSuffix
$zipName  = "node-$version-$platform.zip"
$zipUrl   = "https://nodejs.org/dist/$version/$zipName"

$installBase = Join-Path $env:LOCALAPPDATA "Programs\nodejs"
New-Item -ItemType Directory -Force -Path $installBase | Out-Null

$tmpDir = Join-Path $env:TEMP ("node-install-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
$zipPath = Join-Path $tmpDir $zipName

try {
  Write-Host "Downloading $zipUrl"
  Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

  Write-Host "Extracting to $installBase"
  Expand-Archive -Path $zipPath -DestinationPath $installBase -Force

  $extractedDir = Join-Path $installBase ("node-" + $version + "-" + $platform)
  if (-not (Test-Path $extractedDir)) {
    throw "Extraction failed; expected folder not found: $extractedDir"
  }

  # Add to user PATH if not present
  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  if (-not $userPath) { $userPath = "" }

  $already = $userPath.Split(";") | Where-Object { $_.Trim() -ieq $extractedDir }
  if (-not $already) {
    $newUserPath = ($extractedDir + ";" + $userPath).TrimEnd(";")
    [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
    Write-Host "Added Node to user PATH: $extractedDir"
  } else {
    Write-Host "Node path already present in user PATH."
  }

  # Also update current session PATH
  $env:Path = $extractedDir + ";" + $env:Path

  Write-Host "Installed Node $version"
  Write-Host "Verify:"
  & node -v
  & npm -v

  Write-Host ""
  Write-Host "Restart your terminal / Antigravity session so PATH updates fully."
} finally {
  if (Test-Path $tmpDir) { Remove-Item -Recurse -Force $tmpDir }
}
