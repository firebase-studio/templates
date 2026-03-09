---
name: create-astro
description: Creates a new Astro project using the official scaffolding tool, with optional templates and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
  - id: template
    name: Template
    type: enum
    default: minimal
    options:
      minimal: Minimal
      blog: Blog
      portfolio: Portfolio
---

## When to Use This Skill

Use this skill when the user wants to create a new Astro project, and wants the project configured with custom AI rules.

## Instructions

1.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

    *Action:* Read `resources/setup_instructions.md`.

2.  **Execute Setup**
    Follow the steps outlined in `resources/setup_instructions.md` to:
    - Create the Astro project (using the `workspace_name` and `template` inputs).
    - Install dependencies.
    - Create the `.agent/rules/astro.md` file using the content from `resources/ai_rules.md`.
      - Ensure the `.agent/rules/` directory exists.

3.  **Final Verification**
    Check that:
    - `package.json` exists in the new project
    - `.agent/rules/astro.md` exists
    - `src/pages/index.astro` exists
