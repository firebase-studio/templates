---
name: create-adk-project
description: Creates a new ADK project with a Nix-based environment and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
---

## When to Use This Skill

Use this skill when a user wants to start a new ADK (Agent Development Kit) project. This skill will bootstrap a complete project structure with a reproducible development environment using Nix.

## Instructions

1.  **Create Project Files**
    Create the core project files within the directory specified by `workspace_name`.

    *Action:*
    - Create a `shell.nix` file for the Nix environment.
    - Create a `requirements.txt` file for Python dependencies.
    - Create a `devserver.sh` script to run the application.
    - Create a `.gitignore` file.

2.  **Install AI Rules**
    Copy the predefined AI rules into the project's `.agent/rules/` directory. This allows the AI assistant to have context-specific rules for the project.

    *Action:*
    - Create the `.agent/rules/` directory inside the new project.
    - Copy the content from `skills/adk/resources/airules.md` to `{{workspace_name}}/.agent/rules/adk.md`.

3.  **Final Verification**
    Check that all the necessary project files and the AI rules have been created successfully in the `{{workspace_name}}` directory.

    *Action:*
    - Verify that `requirements.txt` exists.
    - Verify that `devserver.sh` exists.
    - Verify that `.agent/rules/adk.md` exists.
