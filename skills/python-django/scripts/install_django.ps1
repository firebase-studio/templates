
#Requires -Version 5.1
<#
.SYNOPSIS
  Creates a new Python Django project.
#>
param (
  # The name for your new project.
  [string]$ProjectName = "my-django-app"
)

# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

$skillDir = "skills/python-django"

# Create the new project directory
if (Test-Path -Path $ProjectName) {
  throw "Error: Directory '$ProjectName' already exists."
}
New-Item -ItemType Directory -Path "$ProjectName/mysite" | Out-Null

# Create a virtual environment
python -m venv "$ProjectName/venv"

# Install Django in the virtual environment
& "$ProjectName/venv/Scripts/pip.exe" install Django

# Create the Django project
& "$ProjectName/venv/Scripts/django-admin.exe" startproject mysite "$ProjectName/mysite"

# Create requirements.txt
& "$ProjectName/venv/Scripts/pip.exe" freeze | Out-File -FilePath "$ProjectName/mysite/requirements.txt"

# Create the devserver.bat script
$devserverContent = @"
@echo off
setlocal
call venv\Scripts\activate.bat
python mysite/manage.py runserver 0.0.0.0:%PORT%
endlocal
"@
$devserverContent | Out-File -FilePath "$ProjectName/devserver.bat" -Encoding utf8

# Create the .idx directory and copy the AI rules
New-Item -ItemType Directory -Path "$ProjectName/.idx" -ErrorAction SilentlyContinue | Out-Null
Copy-Item -Path "$skillDir/resources/airules.md" -Destination "$ProjectName/.idx/airules.md"
Copy-Item -Path "$skillDir/resources/airules.md" -Destination "$ProjectName/GEMINI.md"

Write-Host "✅ Successfully created Django project '$ProjectName'"
