# Transportable Project Skills

This directory contains a collection of "skills" that define how to bootstrap new projects for various frameworks and technologies. These skills are designed to be transportable and can be used by automation tools like Google Antigravity to create new projects outside of the standard Firebase Studio UI.

## How It Works

Each skill is a self-contained directory that includes:

1.  **`skill.md`**: A central manifest file containing:
    *   **YAML Frontmatter**: Machine-readable metadata including the skill's name, description, and the sequence of `setup` and `start` commands required to bootstrap and run the project.
    *   **Markdown Guide**: Human-readable documentation covering prerequisites, manual installation steps, and platform-specific notes.
2.  **`resources/`**: An optional directory containing boilerplate code, assets, or configuration files that should be copied into the newly created project.

An automation tool can discover skills by scanning this directory, parse the `skill.md` files to get the execution steps, and run the commands to generate a fully configured project from scratch.
