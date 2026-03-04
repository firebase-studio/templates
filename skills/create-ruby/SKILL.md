---
name: create-ruby
description: Creates a new Ruby API workspace.
metadata:
  category: ["Backend", "API"]
  tags: ["ruby", "sinatra", "bundler"]
  version: "1.0.0"
  author: "Google"
---

## When to Use This Skill

Use this skill when the user wants to create a new Ruby API Starter workspace.

## Instructions

1. **Check Prerequisites**
   Before doing anything else, verify that Ruby is available on the system.

   *Action:* Read `resources/setup_instructions.md` and follow **Section 1 (Prerequisites)** to check for Ruby and install it if missing.

2. **Analyse the Repository**
   Fetch and inspect the file listing of the given GitHub public URL(https://github.com/firebase-studio/templates/tree/main/ruby) so you understand the template structure before copying anything.

   *Action:* Follow **Section 2 (Analyse Repository)** in `resources/setup_instructions.md`.

3. **Ask for Workspace Name**
   Ask the user what they would like to name their workspace folder.

   *Action:* Prompt the user:
   > "What would you like to name your workspace? (default: `ruby-app`)"

   Accept their input or fall back to the default name `ruby-app`. Store this as `$WS_NAME`.

4. **Create Workspace & Copy Files**
   Copy the template contents into the new workspace directory.

   *Action:* Follow **Section 3 (Create Workspace & Copy Files)** in `resources/setup_instructions.md`.

5. **Install Dependencies**
   Install all Ruby gem dependencies via Bundler.

   *Action:* Follow **Section 4 (Install Dependencies)** in `resources/setup_instructions.md`.

6. **Final Verification**
   Confirm the workspace is correctly set up.

   *Action:* Check that the following exist inside `$WS_NAME`:
   - `Gemfile`
   - `app.rb`
   - `.agent/rules/ruby.md`
