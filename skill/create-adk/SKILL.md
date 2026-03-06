---
name: create-adk-project
description: Creates a new ADK project by copying template files and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
---

## When to Use This Skill

Use this skill when the user wants to create a new Python-based agent project using the Agent Development Kit (ADK) from the standard template and run it locally.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install prerequisites.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Ensure Python (3.10+) and the ADK are installed.
   - Create the workspace folder (using the `workspace_name` input).
   - Copy template files from `skills/create-adk/template` into the new workspace.
   - Create the `.agent/rules/adk-app.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agent/rules/` directory exists.

3. **Final Verification**
   Check that:
   - `main.py` exists in the new project
   - `requirements.txt` exists in the new project
   - `devserver.sh` exists in the new project
   - The `agents/` directory exists in the new project
   - The `tools/` directory exists in the new project
   - `.agent/rules/adk-app.md` exists
