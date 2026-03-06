# Prompt the user for a project name.
$ProjectName = Read-Host -Prompt "Enter the project name (default: my-postgres-project)"

# If no project name is entered, use the default.
if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    $ProjectName = "my-postgres-project"
}

# Copy the pre-configured postgres app template to the new project directory.
Copy-Item -Path "postgres/app" -Destination $ProjectName -Recurse -Force

Write-Host "PostgreSQL project '$ProjectName' created successfully."
