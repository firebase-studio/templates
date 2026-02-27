---
name: create-eleventy
description: Creates a new Eleventy project and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
---

## When to Use This Skill

Use this skill when the user wants to create a new Eleventy project and wants the project configured with custom AI rules.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Create the Eleventy project (using the `workspace_name` input).
   - Install dependencies.
   - Create the `.agent/rules/eleventy.md` file using the content from `resources/airules.md`.
     - Ensure the `.agent/rules/` directory exists.

3. **Final Verification**
   Check that:
   - `package.json` exists in the new project.
   - `index.md` exists.
   - `.agent/rules/eleventy.md` exists.
