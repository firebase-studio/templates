#!/bin/bash

# Prompt the user to choose a template
echo "Choose a MongoDB template:"
select template in "express" "flask" "blank"; do
    case $template in
        express|flask|blank)
            echo "You chose the '$template' template."
            break
            ;;
        *)
            echo "Invalid option. Please choose 1, 2, or 3."
            ;;
    esac
done

# Prompt the user for a project name.
read -p "Enter the project name (default: my-mongodb-$template-project): " ProjectName

# If no project name is entered, use the default.
if [ -z "$ProjectName" ]; then
    ProjectName="my-mongodb-$template-project"
fi

# Copy the pre-configured mongodb app template to the new project directory.
echo "Creating project from template 'mongodb/$template'..."
cp -r "mongodb/$template" "$ProjectName"

echo "MongoDB project '$ProjectName' created successfully."
