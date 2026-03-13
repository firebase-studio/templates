---
name: create-react-vite
displayName: Create React Vite App
description: Creates a new React project using Vite.
owner: google
tags: [react, vite, web]
inputs:
  - name: workspace_name
    type: string
    description: The name of the new project and directory.
  - name: language
    type: string
    description: The language for the project.
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
   - Create the `.agents/rules/react_vite.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agents/rules/` directory exists.
