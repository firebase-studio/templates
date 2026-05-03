#!/bin/bash

# Prompt the user for a project name.
read -p "Enter the project name (default: my-postgres-project): " projectName

# If no project name is entered, use the default.
if [ -z "$projectName" ]; then
  projectName="my-postgres-project"
fi

# Copy the pre-configured postgres app template to the new project directory.
cp -r postgres/app/ "$projectName"

echo "PostgreSQL project \'"$projectName"\' created successfully."
