param(
  [Parameter(Mandatory=$true)]
  [string]$Dest
)

$ErrorActionPreference = "Stop"

function Is-Dir-Empty([string]$path) {
  if (!(Test-Path $path)) { return $true }
  return -not (Get-ChildItem -LiteralPath $path -Force | Select-Object -First 1)
}

# Resolve destination
$destPath = Resolve-Path -LiteralPath (Join-Path (Get-Location) $Dest) -ErrorAction SilentlyContinue
if (-not $destPath) {
  $destPath = Join-Path (Get-Location) $Dest
} else {
  $destPath = $destPath.Path
}

if (Test-Path $destPath) {
  if (-not (Is-Dir-Empty $destPath)) {
    throw "Destination exists and is not empty: $destPath"
  }
} else {
  New-Item -ItemType Directory -Path $destPath | Out-Null
}

# Script path: <repo>\skills\firebase-studio-go-api\scripts\scaffold.ps1
# Repo root is 3 levels up.
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..") | Select-Object -ExpandProperty Path
$localTemplate = Join-Path $repoRoot "go\api"

if (Test-Path $localTemplate) {
  Write-Host "Using local template at: $localTemplate"
  Copy-Item -Path (Join-Path $localTemplate "*") -Destination $destPath -Recurse -Force
  Write-Host "Scaffolded to: $destPath"
  Write-Host "Next: cd `"$destPath`" ; go test ./... ; go run ."
  exit 0
}

# Fallback: sparse clone from GitHub (for global-installed skill usage)
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  throw "git is required to fetch the template remotely, but was not found."
}

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("fs-templates-" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tmp | Out-Null

try {
  Write-Host "Local repo not found. Fetching from GitHub into: $tmp"
  git clone --depth 1 --filter=blob:none --sparse https://github.com/firebase-studio/templates.git $tmp | Out-Null
  Set-Location $tmp
  git sparse-checkout set go/api | Out-Null

  $remoteTemplate = Join-Path $tmp "go\api"
  if (-not (Test-Path $remoteTemplate)) {
    throw "Remote template path not found after clone: $remoteTemplate"
  }

  Copy-Item -Path (Join-Path $remoteTemplate "*") -Destination $destPath -Recurse -Force
  Write-Host "Scaffolded to: $destPath"
  Write-Host "Next: cd `"$destPath`" ; go test ./... ; go run ."
}
finally {
  Set-Location $PSScriptRoot
  if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
}
