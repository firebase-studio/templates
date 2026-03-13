---
name: create-cpp-api
description: Creates a new C++ API project by copying the cpp/app template files and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
---

## When to Use This Skill

Use this skill when the user wants to create a minimal C++ HTTP API project from the C++ API template (`cpp/app`) and run it locally using Docker.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Ensure Docker is installed.
   - Create the workspace folder (using the `workspace_name` input).
   - Copy template files from `cpp/app` into the new workspace.
   - Create the `.agents/rules/cpp-api.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agents/rules/` directory exists.

3. **Final Verification**
   Check that:
   - `cloud_run_hello.cc` exists in the new project
   - `CMakeLists.txt` exists in the new project
   - `Dockerfile` exists in the new project
   - `docker-compose.yml` exists in the new project
   - `.agents/rules/cpp-api.md` exists
