# Template Administration

This directory contains scripts for maintaining and updating the ADK template. These scripts are intended for template administrators and are not part of the user-facing template code.

## Scripts

- **`refresh_context.sh`**: This is the primary script for keeping the template's AI context up-to-date. It downloads the latest documentation from the official `google/adk-python` repository and uses `sed` and `awk` to update the relevant sections of `.idx/airules.md`.

- **`refresh_context_with_gemini_cli.sh`**: This is an experimental version of the refresh script that uses the Gemini CLI instead of traditional shell tools to perform the update. It is provided for testing and evaluation purposes.

### Usage

These scripts are designed to be run from the parent `adk` directory:

```bash
# To run the stable script
bash .template_admin/refresh_context.sh
```
