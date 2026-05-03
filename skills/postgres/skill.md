---
name: postgres
description: Creates a new PostgreSQL database project using a pre-configured development environment with custom AI rules.
---

## When to Use This Skill

Use this skill when the user wants to create a new, ready-to-use PostgreSQL database environment. The skill scaffolds a complete project with a running database server, a pre-defined schema, and example data.

## Instructions

1. **Read Setup Instructions**

   Review the [setup instructions](resources/setup_instructions.md) to understand how the project is initialized.

   *Action: Read `resources/setup_instructions.md`.*

2. **Create the Project**

    This skill uses a script to create the project. The script will copy the necessary files and set up the initial project structure.

   *Action: `run_terminal_command(command='bash skills/postgres/scripts/install_postgres.sh', windowsCommand='powershell -File skills/postgres/scripts/install_postgres.ps1')`.*
