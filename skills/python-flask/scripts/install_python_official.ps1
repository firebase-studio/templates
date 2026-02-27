#Requires -Version 5.1
#
# Installs the Python Flask starter project for Windows.
# This script is self-sufficient and handles its own dependencies using Nix.
# It can be run with arguments or in interactive mode.

# --- Argument Parsing & Interactive Mode ---
param(
    [string]$ProjectDir,
    [string]$PackageManager,
    [string]$AppType
)

if ([string]::IsNullOrEmpty($ProjectDir)) {
    # --- INTERACTIVE MODE ---
    Write-Host " Entering interactive mode to create a new Python Flask project..."

    # 1. Get Project Name from user input
    $UserProjectDir = Read-Host -Prompt "Enter project name (default: my-flask-project)"
    if ([string]::IsNullOrWhiteSpace($UserProjectDir)) {
        $ProjectDir = "my-flask-project"
    }
    else {
        $ProjectDir = $UserProjectDir
    }
    Write-Host " Project will be created in: '$ProjectDir'"

    # 2. Present a menu to select the Package Manager
    $packageOptions = @("pip (standard Python)", "poetry (modern dependency management)")
    $packageChoice = $host.ui.PromptForChoice(" Select a package manager", "", $packageOptions, 0)
    if ($packageChoice -eq 0) { $PackageManager = "pip" } else { $PackageManager = "poetry" }

    # 3. Present a menu to select the Application Type
    $appOptions = @("web (Flask with a frontend)", "api (Flask for a JSON API)")
    $appChoice = $host.ui.PromptForChoice(" Select an application type", "", $appOptions, 0)
    if ($appChoice -eq 0) { $AppType = "web" } else { $AppType = "api" }
}
else {
    # --- NON-INTERACTIVE (AGENT) MODE ---
    if ([string]::IsNullOrEmpty($PackageManager) -or [string]::IsNullOrEmpty($AppType)) {
        Write-Host "Usage: .\install.ps1 -ProjectDir <project-directory> -PackageManager <pip|poetry> -AppType <web|api>"
        Write-Host "Or run without arguments for interactive mode: .\install.ps1"
        exit 1
    }
}

# --- Script Body ---

Write-Host " Creating a new Python Flask project in '$ProjectDir'..."

# 1. Copy source files.
Write-Host " Copying template files for ${PackageManager}/${AppType}..."
$SourcePath = "python-flask/${PackageManager}/${AppType}"
Copy-Item -Path $SourcePath -Destination $ProjectDir -Recurse -Force

# 2. Adjust permissions (In PowerShell, file permissions are generally handled differently).
Write-Host " Setting file permissions..."

# 3. Generate Nix configuration.
Write-Host "  Generating Nix environment configuration..."
New-Item -Path "$ProjectDir/.idx" -ItemType Directory -Force | Out-Null

# The nix-shell command is cross-platform. The backtick ` escapes the inner quotes.
$nixCommand = "nix-shell -p j2cli nixfmt --run `"packageManager=${PackageManager} type=${AppType} j2 'python-flask/devNix.j2' -o '${ProjectDir}/.idx/dev.nix' ; nixfmt '${ProjectDir}/.idx/dev.nix'`""
Invoke-Expression $nixCommand

# 4. Copy AI rules.
Write-Host " Copying AI rules..."
Copy-Item -Path "python-flask/.idx/airules.md" -Destination "$ProjectDir/.idx/airules.md" -Force
Copy-Item -Path "python-flask/.idx/airules.md" -Destination "$ProjectDir/GEMINI.md" -Force

Write-Host " Project setup complete! Your Flask app is ready in '$ProjectDir'."
