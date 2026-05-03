# Installs the latest Node.js LTS from official nodejs.org releases (user-local install).
# - Detects CPU architecture
# - Fetches latest LTS from Node dist index.json
# - Downloads the official zip
# - Extracts to $env:LocalAppData/nodejs/<version>
# - Adds to user PATH (no sudo required)
# - Prompts to restart terminal


# Helper to get latest LTS version number from Node.js dist index.json
function Get-LatestLtsVersion {
    $url = "https://nodejs.org/dist/index.json"
    try {
        $json = Invoke-RestMethod -Uri $url
        $ltsVersion = $json | Where-Object { $_.lts } | Select-Object -First 1 | ForEach-Object { $_.version }
        if ($ltsVersion) {
            return $ltsVersion
        } else {
            throw "Could not find LTS version in $url"
        }
    } catch {
        Write-Error "Error fetching or parsing Node.js version data: $_"
        exit 1
    }
}

# Helper to get platform/arch suffix for official release asset
function Get-PlatformSuffix {
    $arch = $env:PROCESSOR_ARCHITECTURE
    switch ($arch) {
        "AMD64" { return "win-x64" }
        "ARM64" { return "win-arm64" }
        default { Write-Error "Unsupported architecture: $arch"; exit 1 }
    }
}

# Helper to parse major version from version string (e.g., "v20.10.0" -> 20)
function Get-MajorVersion($v) {
    return ($v -replace "^v") -split '\.' | Select-Object -First 1
}

# If Node already installed and >= 20, do nothing.
if (Get-Command node -ErrorAction SilentlyContinue) {
    $existing = (node -v)
    $major = Get-MajorVersion $existing
    if ($major -ge 20) {
        Write-Output "Node is already installed ($existing). No action needed."
        $npmV = (npm -v)
        Write-Output "npm version: $npmV"
        exit 0
    }
    Write-Output "Node detected ($existing) but is < 20; proceeding to install latest LTS..."
}

$version = Get-LatestLtsVersion
$platform = Get-PlatformSuffix
$zipName = "node-$version-$platform.zip"
$zipUrl = "https://nodejs.org/dist/$version/$zipName"

$installBase = "$env:LOCALAPPDATA\nodejs"
if (-not (Test-Path $installBase)) {
    New-Item -ItemType Directory -Path $installBase | Out-Null
}

$tmpDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString()))

Write-Output "Downloading $zipUrl"
$zipPath = Join-Path $tmpDir.FullName $zipName
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

$extractedDirName = "node-$version-$platform"
$extractedDir = Join-Path $installBase $extractedDirName

Write-Output "Extracting to $extractedDir"
Expand-Archive -Path $zipPath -DestinationPath $installBase

if (-not (Test-Path $extractedDir)) {
    Write-Error "Extraction failed; expected folder not found: $extractedDir"
    exit 1
}

# Add to User PATH
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$extractedDir*") {
    Write-Output "Adding Node to user PATH"
    $newPath = "$extractedDir;$userPath"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")
}

# Also update current session PATH
$env:Path = "$extractedDir;" + $env:Path

Write-Output "Installed Node $version"
Write-Output "Verify:"
node -v
npm -v

Write-Output ""
Write-Output "Restart your terminal so PATH updates fully take effect."

# Clean up temp folder
Remove-Item -Recurse -Force $tmpDir
