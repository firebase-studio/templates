---
name: create-react-vite
description: Creates a new React project using Vite with optional TypeScript support and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
  - id: language
    name: Language
    type: enum
    default: js
    options:
      js: JavaScript
      ts: TypeScript
---

## When to Use This Skill

Use this skill when the user wants to create a new React project using Vite, with a choice of language, and wants the project configured with custom AI rules.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Create the Vite project (using the `workspace_name` and `language` inputs).
   - Install dependencies.
   - Create the `.idx/airules.md` and `GEMINI.md` files using the content from `resources/ai_rules.md`.
     - Ensure the `.idx/` directory exists.

3. **Final Verification**
   Check that:
   - `package.json` exists in the new project directory.
   - `.idx/airules.md` exists.
   - `GEMINI.md` exists.
   - `src/App.tsx` (for TypeScript) or `src/App.jsx` (for JavaScript) exists in the project's root.
