---
name: create-remix
description: Creates a new Remix project with TypeScript support and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
---

## When to Use This Skill

Use this skill when the user wants to create a new Remix project using `create-react-router`, and wants the project configured with custom AI rules.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Create the Remix project (using the `workspace_name` input).
   - Install dependencies.
   - Create the `.agent/rules/remix.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agent/rules/` directory exists.

3. **Final Verification**
   Check that:
   - `package.json` exists in the new project.
   - `.agent/rules/remix.md` exists.
   - `app/root.tsx` exists.
