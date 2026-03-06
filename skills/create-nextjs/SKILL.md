
---
name: create-nextjs
display: Create Next.js
description: Creates a new Next.js project.
owner: google
tags: [nextjs, react, web]
inputs:
  - name: workspace_name
    type: string
    description: The name of the new project and directory.
  - name: language
    type: string
    description: The language for the project.
    default: ts
    options:
      js: JavaScript
      ts: TypeScript
  - name: srcDir
    type: boolean
    description: Whether to use a src/ directory.
    default: true
  - name: eslint
    type: boolean
    description: Whether to use ESLint.
    default: true
  - name: app
    type: boolean
    description: Whether to use the App Router.
    default: true
  - name: tailwind
    type: boolean
    description: Whether to use Tailwind CSS.
    default: true
---

## When to Use This Skill

Use this skill when the user wants to create a new Next.js project, with a choice of language, and wants the project configured with custom AI rules.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Create the Next.js project (using the `workspace_name` and `language` inputs).
   - Install dependencies.
   - Create the `.agent/rules/nextjs.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agent/rules/` directory exists.
