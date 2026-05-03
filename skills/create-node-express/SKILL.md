---
name: create-node-express
description: Creates a new Node.js Express project and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
  - id: project_type
    name: Project Type
    type: string
    description: "The type of project to create: 'api' or 'web'"
    default: "web"
  - id: language
    name: Language
    type: string
    description: "The language to use: 'js' or 'ts'"
    default: "js"
---

## When to Use This Skill

Use this skill when the user wants to create a new Node.js project using Express, and wants the project configured with custom AI rules.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Create the Node.js Express project (using the `workspace_name` input).
   - Install dependencies.
   - Create the `.agents/rules/node-express.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agents/rules/` directory exists.
