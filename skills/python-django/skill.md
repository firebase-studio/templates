
---
name: python-django
description: Creates a new Python Django project, setting up a virtual environment, installing Django, and adding custom AI rules.

inputs:
  - id: projectName
    name: Project Name
    type: string
    description: The name of the folder for the new project (e.g., my-django-app).
---

## When to Use This Skill

Use this skill when the user wants to create a new Python Django project, and wants the project automatically configured with an isolated virtual environment and custom AI rules.

## Instructions

1. **Read Setup Instructions**

   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

   *Action: Read `resources/setup_instructions.md`.*

2. **Guide the User**

   Walk the user through the steps outlined in `resources/setup_instructions.md` to:
   - Ensure Python and pip are installed.
   - Create the Django project using the `projectName` input. The setup scripts handle the rest.
   - Note that dependency installation is handled automatically by the script.
   - Note that the `.idx/airules.md` and `GEMINI.md` files are also created automatically.

3. **Final Verification**

   Verify that the project was created successfully by checking for the existence of the new project directory and key files within it.

   *Action: `list_files(path=projectName)` and confirm that `manage.py` and a `devserver` script exist.*
