---
name: create-gemini-maps
description: Creates a new gemini-maps workspace.
metadata:
  category: ["Web app"]
  tags: ["gemini-maps"]
  version: "1.0.0"
  author: "Google"
---

# Gemini Maps Setup

## When to Use This Skill

Use this skill when the user wants to scaffold a new `gemini-maps` workspace.

## Instructions

1.  **Ask for User Input: Workspace Name**
    Before proceeding, you MUST ask the user to provide a name for the new workspace they want to create.
    
    *Action:* Mandatorily ask for the workspace name before doing anything else. Wait for their response. Let `$WS_NAME` refer to this name.

2.  **Verify Prerequisites (Node.js)**
    Check if `node` and `npm` are installed and available on the user's machine.
    
    *Action:* Execute the prerequisite checking script located at `scripts/check_prereqs.sh` relative to this skill's directory. This script will verify the presence of Node.js and attempt to install it if it is missing.

3.  **Analyse the Repository and Setup Workspace**
     Fetch and inspect the file listing of the given GitHub public URL so you understand the template structure before copying anything.
    
    *Action:* 
    *   Analyze and fetch the repository: `https://github.com/firebase-studio/templates/tree/main/gemini-maps`
    *   Create a new directory named `$WS_NAME`.
    *   Copy the contents from the repo template's app folder into `$WS_NAME`, but **exclude** the `.idx` folder initially from the general copy.
    *   Create the `.agent/rules` directory inside the new workspace (`$WS_NAME/.agent/rules`).
    *   Use the contents of the fetched `.idx/airules` file to create `.agent/rules/gemini_maps.md` in the new workspace.
    *   Copy all other files from the `.idx` directory into the root of the `$WS_NAME` workspace.

4.  **Install Dependencies**
    Install all required packages for the new project.
    
    *Action:* Navigate into the `$WS_NAME` directory and install the dependencies based on the `package.json`.

5.  **Final Verification**
    Verify that the workspace was created successfully and essential files exist.
    
    *Action:* Check that the following files exist relative to the workspace root:
    *   `package.json`
    *   `src/main.ts`

7.  **Run the Server**
    Start the development server for the newly created workspace.
    
    *Action:* Execute the available command to start the server (e.g., `npm run dev` or `npm start`) from within the `$WS_NAME` directory.
