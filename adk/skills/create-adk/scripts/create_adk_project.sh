#!/bin/bash

# This script sets up an ADK project in the current directory.
# WARNING: This may overwrite existing files.

echo "Setting up ADK project in the current directory..."

# 1. Create requirements.txt
echo "Creating requirements.txt"
cat <<EOF > "./requirements.txt"
google-adk
EOF

# 2. Create devserver.sh
echo "Creating devserver.sh"
cat <<'EOF' > "./devserver.sh"
#!/bin/bash
# Activate virtual environment and run the main Python script

# Check if the virtual environment exists
if [ ! -d ".venv" ]; then
    echo "Virtual environment not found. Please run the setup script first."
    exit 1
fi

source .venv/bin/activate
python main.py
EOF
chmod +x "./devserver.sh"

# 3. Create .gitignore
echo "Creating .gitignore"
cat <<'EOF' > "./.gitignore"
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# PyInstaller
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
.hypothesis/
.pytest_cache/

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDEs
.idea/
.vscode/
EOF

# 4. Create main.py
echo "Creating main.py"
cat <<'EOF' > "./main.py"
from adk.api import app

@app.agent()
def on_agent_request(request):
    """This is the entry point for the agent."""
    return "Hello from the ADK!"

if __name__ == '__main__':
    app.run(debug=True)
EOF

# 5. Set up Virtual Environment and Install Dependencies
echo "Setting up virtual environment and installing dependencies..."
python3 -m venv .venv
source .venv/bin/activate

echo "Installing dependencies with pip..."
pip install -r requirements.txt
deactivate

# 6. Install AI Rules
# This assumes the script is run from the project root directory.
echo "Installing AI rules..."
if [ -f "skills/adk/resources/airules.md" ]; then
    mkdir -p "./.agent/rules"
    cp skills/adk/resources/airules.md "./.agent/rules/adk.md"
else
    echo "Warning: AI rules source file not found. Skipping installation."
fi


# 7. Final Confirmation
cat <<EOF

✅ Successfully created ADK project in the current directory.

To run this project:

1.  Run the development server:
    ./devserver.sh

EOF
