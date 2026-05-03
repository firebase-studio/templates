# Installs the specified backend (Node.js or Go) for HTMX development.

param (
    [Parameter(Mandatory=$false)]
    [ValidateSet('node', 'go')]
    [string]$Backend = 'go'
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# --- Helper Functions ---

function Get-MajorVersion([string]$v) {
    $v = $v.Trim()
    if ($v.StartsWith("v")) { $v = $v.Substring(1) }
    return [int]($v.Split(".")[0])
}

function Update-UserPath($installDir, $marker) {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $pathItems = $userPath -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }

    if ($pathItems -notcontains $installDir) {
        $newUserPath = ($installDir + ";" + $userPath).TrimEnd(";")
        [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
        Write-Host "Added $Backend for HTMX to user PATH: $installDir"
    } else {
        Write-Host "$Backend path for HTMX already in user PATH."
    }
    # Update current session PATH
    $env:Path = $installDir + ";" + $env:Path
}


# --- Installation Functions ---

function Install-Node {
    Write-Host "Setting up Node.js for HTMX..."

    try {
        $existing = & node -v 2>$null
        if ($LASTEXITCODE -eq 0) {
            $major = Get-MajorVersion $existing
            if ($major -ge 18) {
                Write-Host "Node.js >=18 for HTMX is already installed ($existing). No action needed."
                Write-Host "npm version: " -NoNewline; & npm -v
                return
            }
            Write-Host "An older Node.js version was detected ($existing); installing required LTS version."
        }
    } catch { # node not found
    }

    $lts = (Invoke-RestMethod -Uri "https://nodejs.org/dist/index.json") | Where-Object { $_.lts -ne $false } | Select-Object -First 1
    if (-not $lts) { throw "Could not determine latest Node.js LTS for HTMX." }
    $version = $lts.version

    $arch = $env:PROCESSOR_ARCHITECTURE
    $platform = switch ($arch) {
        "AMD64" { "win-x64" } 
        "ARM64" { "win-arm64" } 
        default { throw "Unsupported Windows architecture for HTMX Node.js: $arch" }
    }

    $zipName = "node-$version-$platform.zip"
    $zipUrl = "https://nodejs.org/dist/$version/$zipName"
    
    $installBase = Join-Path $env:LOCALAPPDATA "Programs\nodejs"
    $installDir = Join-Path $installBase "node-$version-$platform"
    New-Item -ItemType Directory -Force -Path $installBase | Out-Null

    $tmpDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP ("htmx-install-" + [guid]::NewGuid().ToString("N")))
    $zipPath = Join-Path $tmpDir $zipName

    try {
        Write-Host "Downloading Node.js LTS for HTMX: $zipUrl"
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
        Write-Host "Extracting to $installDir"
        Expand-Archive -Path $zipPath -DestinationPath $installDir -Force

        Update-UserPath $installDir "# >>> IDX Node for HTMX >>>"
        
        Write-Host ""
        Write-Host "Successfully installed Node.js $version for HTMX."
        Write-Host "Please restart your terminal, then verify the installation:"
        Write-Host "  node -v"
        Write-Host "  npm -v"
    } finally {
        if (Test-Path $tmpDir) { Remove-Item -Recurse -Force $tmpDir }
    }
}

function Install-Go {
    Write-Host "Setting up Go for HTMX..."

    if (Get-Command go -ErrorAction SilentlyContinue) {
        Write-Host "Go for HTMX is already installed. No action needed."
        & go version
        return
    }

    $releases = Invoke-RestMethod -Uri "https://go.dev/dl/?mode=json"
    $latest = $releases[0]
    $version = $latest.version

    $fileInfo = $latest.files | Where-Object { $_.os -eq 'windows' -and $_.arch -eq 'amd64' -and $_.kind -eq 'archive' } | Select-Object -First 1
    if (-not $fileInfo) { throw "Could not find a Go release for your platform (Windows/amd64)." }
    
    $zipName = $fileInfo.filename
    $zipUrl = "https://go.dev/dl/$zipName"

    $installBase = Join-Path $env:LOCALAPPDATA "Programs"
    $installDir = Join-Path $installBase "go"
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null

    $tmpDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP ("htmx-go-install-" + [guid]::NewGuid().ToString("N")))
    $zipPath = Join-Path $tmpDir $zipName
    
    try {
        Write-Host "Downloading Go for HTMX: $zipUrl"
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

        Write-Host "Extracting Go..."
        Expand-Archive -Path $zipPath -DestinationPath $installBase -Force
        # The archive extracts to a 'go' folder, so the final path is correct.

        $binPath = Join-Path $installDir "bin"
        Update-UserPath $binPath "# >>> IDX Go for HTMX >>>"

        Write-Host ""
        Write-Host "Successfully installed Go $version for HTMX."
        Write-Host "Please restart your terminal, then verify the installation:"
        Write-Host "  go version"

    } finally {
        if (Test-Path $tmpDir) { Remove-Item -Recurse -Force $tmpDir }
    }
}


# --- Main Logic ---

switch ($Backend) {
    'node' { Install-Node } 
    'go'   { Install-Go }
}
