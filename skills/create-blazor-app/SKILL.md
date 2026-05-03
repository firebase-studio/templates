---
name: create-blazor-app
description: Creates a new Blazor Server App and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
---

## When to Use This Skill

Use this skill when the user wants to create a new Blazor project and wants the project configured with custom AI rules.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Create the Blazor project (using the `workspace_name` input).
   - Create the `.agents/rules/dotnet.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agents/rules/` directory exists.

3. **Final Verification**
   Check that:
   - A `.csproj` file exists in the new project.
   - `.agents/rules/dotnet.md` exists.
   - `Program.cs` and a `Components` directory exist.
