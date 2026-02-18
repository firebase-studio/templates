---
name: create_nextjs_workspace
version: 3.0.0
description: Creates a hyper-opinionated, production-ready Next.js workspace with a single command.

# This skill is hyper-opinionated. It will always create a TypeScript project
# using the App Router, Tailwind CSS, ESLint, and npm.

inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new workspace.
---

## Goal

This skill embodies a philosophy of extreme efficiency. It scaffolds a complete, professional Next.js development environment with zero configuration questions. By asking only for a workspace name, it creates a best-practices project (TypeScript, App Router, Tailwind, ESLint, npm) and installs predefined AI rules, enabling a developer to go from idea to code in seconds.

## Instructions for an Intelligent Agent

1.  **Gather Input:**
    - Prompt the user for the `workspace_name`. This is the only input required.

2.  **Resolve Resource Path:**
    Before executing, you must determine the absolute path to the `airules.md` file. It is located at `resources/airules.md` relative to the location of THIS skill file. Store this resolved path in a variable (e.g., `RULES_FILE_PATH`).

3.  **Execute Atomic Setup Command:**
    Execute the following command block as a single, atomic operation. The entire block should succeed or fail as a whole. You must substitute the `${workspace_name}` variable.

    ```bash
    # This command block creates a new, opinionated Next.js app, enters the new directory,
    # and copies the AI rules file in a single chained operation.

    # --- Execute Command ---
    # The flags --typescript, --app, --tailwind, --eslint, and --use-npm are intentionally hardcoded
    # to enforce a highly opinionated, best-practices-first workflow.
    npx create-next-app@latest "${workspace_name}" --typescript --app --tailwind --eslint --src-dir --use-npm && \
    cd "${workspace_name}" && \
    mkdir -p .agent && \
    cp "${RULES_FILE_PATH}" .agent/rules.md
    ```

4.  **Verify Success:**
    After the command completes, verify the existence of the directory `"${workspace_name}"` and the file `"${workspace_name}/.agent/rules.md"`.

5.  **Report to User:**
    Inform the user that their new Next.js workspace is ready. Provide the command to navigate into it: `cd "${workspace_name}"`.
