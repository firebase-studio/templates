#!/bin/bash

# This script downloads the latest context files from the ADK repository
# and uses the Gemini CLI to update the .idx/airules.md file.
# This is an EXPERIMENTAL alternative to the sed/awk-based script.
#
# Get the directory of the script itself
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "$SCRIPT_DIR/.." # Change to the parent adk/ directory

AIRULES_PATH=".idx/airules.md"
GEMINI_SETTINGS_PATH=".gemini/settings.json"
LLMS_TXT_PATH="llms-full.txt"
AGENTS_PATH="AGENTS.md"

echo "--- Downloading latest context files... ---"
mkdir -p .gemini
curl -s -o $GEMINI_SETTINGS_PATH https://raw.githubusercontent.com/google/adk-python/main/.gemini/settings.json
curl -s -o $LLMS_TXT_PATH https://raw.githubusercontent.com/google/adk-python/main/llms-full.txt
curl -s -o $AGENTS_PATH https://raw.githubusercontent.com/google/adk-python/main/AGENTS.md
echo "Downloads complete."

# --- Define temp file paths ---
AIRULES_NEW_PATH=".idx/airules.md.new"

if [ ! -f "$AIRULES_PATH" ]; then
    echo "ERROR: $AIRULES_PATH not found. Cannot proceed." >&2
    exit 1
fi

echo "--- Updating .idx/airules.md using Gemini CLI... ---"

# --- The Gemini CLI Prompt ---
# This prompt instructs the model to act like a precise file-updating tool.
# It's told to only replace specific sections and preserve everything else.
PROMPT="You are a script that updates one file based on another. The input you receive contains two files concatenated together: first '$AIRULES_PATH', then 'AGENTS.md'. Your task is to use the content from 'AGENTS.md' to update the content of '$AIRULES_PATH'.

Follow these instructions precisely:
1.  Identify the content of the '## Project Overview' section from the 'AGENTS.md' part of the input.
2.  Replace the content of the '## Project Overview' section in the '$AIRULES_PATH' part of the input with what you just identified.
3.  Identify the content of the '### Python Style Guide' section from the 'AGENTS.md' part of the input.
4.  Replace the content of the '### Python Style Guide' section in the '$AIRULES_PATH' part of the input with what you just identified.
5.  Preserve ALL other content and formatting from the original '$AIRULES_PATH' part of the input exactly as it is.
6.  If there are new sections in AGENTS.md that would be highly relevant to a developer *using* the ADK (not contributing to it), you may cautiously add them. Otherwise, do not add new sections.
7.  Your goal is to make the minimum number of changes necessary. Only add, edit, or remove content in the target sections if the corresponding source content in 'AGENTS.md' has changed. Do not rephrase or 'improve' content that is unchanged.
8.  Output only the full, updated content of the '$AIRULES_PATH' file."

# --- Execute the Gemini CLI command ---
# We concatenate the two files and pipe them to the Gemini CLI's standard input.
cat "$AIRULES_PATH" "$AGENTS_PATH" | gemini -p "$PROMPT" > "$AIRULES_NEW_PATH"

# Check if the new file was created and has content
if [ -s "$AIRULES_NEW_PATH" ]; then
    # Replace the old file with the new one
    mv "$AIRULES_NEW_PATH" "$AIRULES_PATH"
    echo ".idx/airules.md has been successfully updated by Gemini CLI."
else
    echo "ERROR: Gemini CLI failed to generate a new airules.md file." >&2
    # Clean up the empty new file if it exists
    rm -f "$AIRULES_NEW_PATH"
    exit 1
fi

echo "--- Context refresh with Gemini CLI complete. ---"
