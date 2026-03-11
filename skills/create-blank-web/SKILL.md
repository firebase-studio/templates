---
name: create-blank-web
description: Creates a new blank web project using Vite by copying template files and installing custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project.
---

## When to Use This Skill

Use this skill when the user wants to create a new, modern blank web project from the `blank-web` template. This skill sets up a Vite-based development environment.

## Instructions

1.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instructions.md) to understand the full process for initializing the project.

    *Action:* Read `resources/setup_instructions.md`.

2.  **Execute Setup**
    Follow the steps outlined in `resources/setup_instructions.md` to:
    - Ensure **Node.js and npm** are installed, using the provided scripts if necessary.
    - Create the workspace folder (using the `workspace_name` input).
    - Copy the `blank-web` template files into the new workspace.
    - Run `npm install` to install project dependencies.
    - Create the `.agent/rules/blank-web.md` file using the content from `resources/ai_rules.md`.

3.  **Final Verification**
    Check that:
    - `package.json` and `vite.config.js` exist in the new project root.
    - `index.html` and `src/main.js` exist.
    - The `node_modules` directory has been created.
    - `.agent/rules/blank-web.md` exists.
