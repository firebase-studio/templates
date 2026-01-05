#!/bin/sh

# This script is the entrypoint for running the ADK web server in Firebase Studio.
# It activates the virtual environment, loads environment variables, and
# constructs the 'adk web' command with the correct arguments.

# Activate the Python virtual environment.
source .venv/bin/activate

# Load environment variables from .env files if they exist.
# This allows for loading secrets like GOOGLE_API_KEY without checking them into git.
if [ -f .env ]; then
  source .env
fi
if [ -f .env.local ]; then
  source .env.local
fi
if [ -f multi_tool_agent/.env.local ]; then
  source multi_tool_agent/.env.local
fi

# Start building the command string. We start with the base command and required flags.
CMD="adk web --host=0.0.0.0"

# Firebase Studio and other environments provide the port via the $PORT variable.
# We check if $PORT is set and not empty, and only add the --port flag if it is.
# This allows the script to work both in IDX and in a local environment where
# the user might not have set a port.
if [ -n "$PORT" ]; then
  CMD="$CMD --port=$PORT"
fi

# The '.' is a positional argument telling 'adk web' to run the agent
# in the current directory. It must come after all other flags.
CMD="$CMD ."

# Use 'exec' to replace the shell process with the adk command.
# This is a best practice for container entrypoint scripts.
exec $CMD