# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUTHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Official Node.js installation script for Windows (PowerShell).
# Downloads and installs the latest LTS version of Node.js.

# 1. Configuration
$NodeMajorVersion = 20
$InstallPath = "$env:ProgramFiles\nodejs"

# 2. Check for existing Node.js installation
try {
    $currentNodeVersion = (node -v).Substring(1).Split('.')[0]
    if ($currentNodeVersion -ge $NodeMajorVersion) {
        Write-Host "Node.js version ${NodeMajorVersion}.x or higher is already installed."
        exit 0
    }
} catch {
    # Node.js is not installed, proceed with installation
}

# 3. Get the latest LTS version
$response = Invoke-RestMethod -Uri "https://nodejs.org/dist/index.json"
$latestLts = $response | Where-Object { $_.version -match "^v$($NodeMajorVersion)" -and $_.lts } | Select-Object -First 1
$nodeVersion = $latestLts.version.Substring(1)

# 4. Construct download URL and file paths
$downloadUrl = "https://nodejs.org/dist/v$($nodeVersion)/node-v$($nodeVersion)-win-x64.zip"
$zipFile = "$env:TEMP\node.zip"

# 5. Download and extract
Write-Host "Downloading Node.js v$($nodeVersion) from $downloadUrl..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile

Write-Host "Extracting to $InstallPath..."
Expand-Archive -Path $zipFile -DestinationPath "$env:TEMP\node-extracted" -Force
Move-Item -Path "$env:TEMP\node-extracted\*" -Destination $InstallPath -Force

# 6. Add to PATH
Write-Host "Adding Node.js to the system PATH..."
$currentPath = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')
if (-not $currentPath.Contains($InstallPath)) {
    $newPath = "$($InstallPath);$($currentPath)"
    [System.Environment]::SetEnvironmentVariable('PATH', $newPath, 'Machine')
    Write-Host "Node.js has been added to your system PATH."
    Write-Host "Please restart your terminal to apply the changes."
} else {
    Write-Host "Node.js is already in your system PATH."
}

# 7. Clean up
Remove-Item $zipFile -Force
Remove-Item "$env:TEMP\node-extracted" -Recurse -Force

Write-Host "Node.js installation is complete."
