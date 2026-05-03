---
name: create-prisma-sqlite
description: Creates a new Prisma project with a SQLite database.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project.
    default: my-prisma-sqlite-app
---

## When to Use This Skill

Use this skill to create a new Prisma project configured to work with a self-contained SQLite database.

## Instructions

1.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project, check for prerequisites, and run the application.

    *Action:* Read `resources/setup_instructions.md`.

2.  **Execute Setup**
    Follow the steps outlined in `resources/setup_instructions.md` to:
    - Create the project directory and copy the template files.
    - Create the `.agents/rules/prisma-sqlite.md` file using the content from `resources/airules.md`.
    - Install dependencies.
    - Run the database scripts to populate and query the data.

3.  **Final Verification**
    Check that:
    - `package.json` exists in the new project.
    - `.agents/rules/prisma-sqlite.md` exists.
    - The template repository files exist in the new project directory.
