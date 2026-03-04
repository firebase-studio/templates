---
name: python-django
description: Creates a new Python Django project.

parameters:
  projectName:
    type: string
    description: The name for your new project (e.g., my-django-app).

entrypoints:
  - runtime: bash
    entrypoint: scripts/install_django.sh
  - runtime: powershell
    entrypoint: scripts/install_django.ps1
---
# Python Django Project Skill

This skill automates the creation of a new Python Django project within the repository.

## 1. Prerequisites

This skill requires the following to be installed:
- **Python**: Version 3.8 or later.
- **pip**: Should be included with your Python installation.

### Verification

Run the following commands to check if the prerequisites are installed:
- `python --version`
- `pip --version`

## 2. Platform Support

This skill is platform-independent and is expected to work on macOS, Linux, and Windows.

## 3. Manual Usage

While intended for agent use, the skill can be run directly from the command line.

### Arguments

- `<project-name>`: The name of the new folder to create for your project (e.g., `my-django-app`).

### Example

To create a new Django app named `my-django-app`:

**PowerShell**
```powershell
pwsh skills/python-django/scripts/install_django.ps1 -ProjectName my-django-app
```

**Bash**
```bash
bash skills/python-django/scripts/install_django.sh my-django-app
```
