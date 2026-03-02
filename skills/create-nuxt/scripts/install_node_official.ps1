# Installs the latest Node.js LTS from official nodejs.org releases for Nuxt.js development.
# - Detects CPU architecture
# - Fetches latest LTS from Node dist index.json
# - Downloads the official ZIP
# - Extracts to %LOCALAPPDATA%\Programs\nodejs\<version>
# - Adds to user PATH (no admin required)
# - Prompts to restart terminal

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Get-LatestLtsVersion {
  $index = Invoke-RestMethod -Uri "https://nodejs.org/dist/index.json"
  $lts = $index | Where-Object { $_.lts -ne $false } | Select-Object -First 1
  if (-not $lts -or -not $lts.version) {
    throw "Could not determine latest LTS for Nuxt.js from https://nodejs.org/dist/index.json"
  }
  return $lts.version
}

function Get-PlatformSuffix {
  $arch = $env:PROCESSOR_ARCHITECTURE
  switch ($arch) {
    "AMD64" { return "win-x64" }
    "ARM64" { return "win-arm64" }
    "x86"   { return "win-x86" }
    default { throw "Unsupported Windows architecture for Nuxt.js Node.js installation: $arch" }
  }
}

function Get-MajorVersion([string]$v) {
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
      Write-Host "Node.js for Nuxt.js is already installed ($existing). No action needed."
      Write-Host "npm version: " -NoNewline; & npm -v
      exit 0
    }
    Write-Host "An older version of Node.js was detected ($existing); proceeding to install the required LTS version for Nuxt.js."
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
  Write-Host "Downloading Node.js LTS for Nuxt.js: $zipUrl"
  Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

  Write-Host "Extracting Node.js for Nuxt.js to $installBase"
  Expand-Archive -Path $zipPath -DestinationPath $installBase -Force

  $extractedDir = Join-Path $installBase ("node-" + $version + "-" + $platform)
  if (-not (Test-Path $extractedDir)) {
    throw "Extraction failed; expected folder for Nuxt.js Node.js was not found: $extractedDir"
  }

  # Add to user PATH if not present
  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  if (-not $userPath) { $userPath = "" }

  $already = $userPath.Split(";") | Where-Object { $_.Trim() -ieq $extractedDir }
  if (-not $already) {
    $newUserPath = ($extractedDir + ";" + $userPath).TrimEnd(";")
    [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
    Write-Host "Added Node.js for Nuxt.js to user PATH: $extractedDir"
  } else {
    Write-Host "Node.js path for Nuxt.js already present in user PATH."
  }

  # Also update current session PATH
  $env:Path = $extractedDir + ";" + $env:Path

  Write-Host "Successfully installed Node.js $version for Nuxt.js."
  Write-Host "Verify:"
  & node -v
  & npm -v

  Write-Host ""
  Write-Host "To complete the Nuxt.js setup, please restart your terminal so PATH updates are fully applied."
} finally {
  if (Test-Path $tmpDir) { Remove-Item -Recurse -Force $tmpDir }
}