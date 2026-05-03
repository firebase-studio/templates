---
name: python-flask
description: Creates a new Python Flask project, either a web server with a frontend or a JSON API.

parameters:
  projectName:
    type: string
    description: The name for your new project (e.g., my-flask-app).
  packageManager:
    type: string
    description: The package manager to use.
    enum: ['pip', 'poetry']
    default: pip
  type:
    type: string
    description: The type of application to create.
    enum: ['web', 'api']
    default: web

runtime: bash
entrypoint: scripts/install_python_official.sh
---
# Python Flask Project Skill

This skill automates the creation of a new Python Flask project within the repository. It is designed to be executed by an AI agents (Antigravity) but can also be run manually.

## Description

The skill bootstraps a complete, ready-to-code Flask project. It handles copying the correct starter files, configuring the Nix development environment for Firebase Studio, and setting up AI interaction rules.

The generated project can be one of two types:
- **web**: A full-stack Flask application with a simple frontend.
- **api**: A backend-only JSON API.

It also supports two different package managers:
- **pip**: The standard Python package installer.
- **poetry**: A modern Python dependency management tool.

## Antigravity (Agents) Usage

This skill is intended to be used by an AI agents. The agents reads the `skill.yaml` file to understand the available parameters and their possible values. The user can then specify their choices (e.g., "create a flask api with poetry"), and the agents will execute the `install_python_official.sh` script with the correct arguments.

### Parameters

- `packageManager` (string): The package manager to use. (Enum: `pip`, `poetry`. Default: `pip`)
- `type` (string): The type of application to create. (Enum: `web`, `api`. Default: `web`)

## Manual Usage

While intended for agents use, the skill can be run directly from the command line.

### Command

```bash
bash skills/python-flask/scripts/install_python_official.sh <project-directory> <package-manager> <app-type>
```

### Arguments

1.  `project-directory`: The name of the new folder to create for your project (e.g., `my-flask-app`).
2.  `package-manager`: The dependency tool to use (`pip` or `poetry`).
3.  `app-type`: The type of project to create (`web` or `api`).

### Example

```bash
bash skills/python-flask/scripts/install_python_official.sh my-new-api poetry api
```
