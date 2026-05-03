---
name: create-dotnet-web
description: Creates a new .NET minimal web project and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project. Defaults to 'dotnet-web-skill'.
---

## When to Use This Skill

Use this skill when the user wants to create a new, minimal .NET web project. This skill uses the standard `dotnet new web` template and installs a local set of AI rules to assist with development.

## Instructions

1.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install prerequisites.

    *Action:* Read `resources/setup_instructions.md`.

2.  **Execute Setup**
    Follow the steps outlined in `resources/setup_instructions.md` to:
    - Ensure the .NET SDK is installed (Version 8.0+). The skill can help install it.
    - Create the workspace folder (using the `workspace_name` input).
    - Initialize a new .NET minimal web project inside the workspace.
    - Create the `.agents/rules/dotnet-web.md` file using the content from `resources/ai_rules.md`.

3.  **Final Verification**
    Check that:
    - A `.csproj` file exists in the new project.
    - `Program.cs` exists in the new project.
    - `.agents/rules/dotnet-web.md` exists.
