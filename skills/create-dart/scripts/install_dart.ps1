#Requires -RunAsAdministrator

# 1. Determine architecture
$arch = $env:PROCESSOR_ARCHITECTURE
switch ($arch) {
    "AMD64" { $archName = "x64" }
    "ARM64" { $archName = "arm64" }
    default { throw "Unsupported architecture: $arch" }
}

# 2. Get latest stable version
$dartVersion = "3.3.3"
$zipFile = "dartsdk-windows-$archName-release.zip"
$downloadUrl = "https://storage.googleapis.com/dart-archive/channels/stable/release/$dartVersion/sdk/$zipFile"

# 3. Download
$tempDir = "$env:TEMP\dart-sdk-install"
New-Item -ItemType Directory -Force -Path $tempDir
$zipPath = Join-Path $tempDir $zipFile

Write-Host "Downloading from $downloadUrl..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

# 4. Extract and Install
$installDir = "$env:ProgramFiles\Dart"
$sdkDir = "$installDir\dart-sdk"

Write-Host "Extracting to $sdkDir..."
Expand-Archive -Path $zipPath -DestinationPath $installDir -Force

# 5. Update Path
$dartBinPath = "$sdkDir\bin"
$currentPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)

if (-not ($currentPath -split ';') -contains $dartBinPath) {
    Write-Host "Adding $dartBinPath to system PATH..."
    $newPath = "$currentPath;$dartBinPath"
    [System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::Machine)
} else {
    Write-Host "Dart SDK path already in system PATH."
}

# 6. Cleanup
Write-Host "Cleaning up temporary files..."
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "Dart SDK installation complete!"
Write-Host "Please restart your shell for changes to take effect."
