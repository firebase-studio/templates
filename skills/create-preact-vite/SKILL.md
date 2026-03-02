---
name: create-preact-vite
description: Creates a new Preact project using Vite with optional TypeScript support and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
  - id: language
    name: Language
    type: enum
    default: ts
    options:
      js: JavaScript
      ts: TypeScript
---

## When to Use This Skill

Use this skill when the user wants to create a new Preact project using Vite, with either JavaScript or TypeScript, and wants the project configured with custom AI rules.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

   *Action:* Read `resources/setup_instructions.md`.

2. **Guide the User**
   Walk the user through the steps outlined in `resources/setup_instructions.md` to:
   - Ensure Node.js is installed.
   - Create the Preact-Vite project (using the `workspace_name` and `language` inputs).
   - Install dependencies.
   - Create the `.agent/rules/preact.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agent/rules/` directory exists.

3. **Final Verification**
   Check that:
   - `package.json` exists in the new project
   - `.agent/rules/preact.md` exists
   - `index.html` exists
   - `src/main.tsx` (or `src/main.jsx` if using javascript) exists
