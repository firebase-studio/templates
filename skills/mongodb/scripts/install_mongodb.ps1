#!/usr/bin/env pwsh

# Prompt the user to choose a template
$template = Read-Host -Prompt "Choose a MongoDB template (express, flask, or blank)"

while ($template -notin @('express', 'flask', 'blank')) {
    Write-Host "Invalid option. Please choose 'express', 'flask', or 'blank'."
    $template = Read-Host -Prompt "Choose a MongoDB template (express, flask, or blank)"
}

# Prompt the user for a project name.
$ProjectName = Read-Host -Prompt "Enter the project name (default: my-mongodb-$template-project)"

# If no project name is entered, use the default.
if ([string]::IsNullOrEmpty($ProjectName)) {
    $ProjectName = "my-mongodb-$template-project"
}

# Copy the pre-configured mongodb app template to the new project directory.
Write-Host "Creating project from template 'mongodb/$template'..."
Copy-Item -Path "mongodb/$template" -Destination $ProjectName -Recurse

Write-Host "MongoDB project '$ProjectName' created successfully."
