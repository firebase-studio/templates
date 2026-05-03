#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Set project name to the first argument or default to 'my-django-app'
PROJECT_NAME=${1:-my-django-app}

SKILL_DIR="skills/python-django"

# Create the new project directory
if [ -d "$PROJECT_NAME" ]; then
  echo "Error: Directory '$PROJECT_NAME' already exists."
  exit 1
fi
mkdir -p "$PROJECT_NAME/mysite"

# Create a virtual environment
python3 -m venv "$PROJECT_NAME/venv"

# Install Django in the virtual environment
"$PROJECT_NAME/venv/bin/pip" install Django

# Create the Django project
( 
  cd "$PROJECT_NAME/mysite"
  "../venv/bin/django-admin" startproject mysite .
)

# Create requirements.txt
"$PROJECT_NAME/venv/bin/pip" freeze > "$PROJECT_NAME/mysite/requirements.txt"

# Create the devserver.sh script
cat > "$PROJECT_NAME/devserver.sh" << EOL
#!/bin/bash
set -e
source venv/bin/activate
python mysite/manage.py runserver 0.0.0.0:\$PORT
EOL
chmod +x "$PROJECT_NAME/devserver.sh"

# Create the .idx directory and copy the AI rules
mkdir -p "$PROJECT_NAME/.idx"
cp "${SKILL_DIR}/resources/airules.md" "$PROJECT_NAME/.idx/airules.md"

# Also create a GEMINI.md for AI Studio context
cp "${SKILL_DIR}/resources/airules.md" "$PROJECT_NAME/GEMINI.md"


echo "✅ Successfully created Django project '$PROJECT_NAME'"
