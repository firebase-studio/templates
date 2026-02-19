---
name: Nextjs
description: A skill to create a new Next.js application using the official CLI. Requires Node.js and npm.
requirements:
  - name: node
    version: ">=18.0.0"
  - name: npm
    version: ">=8.0.0"
parameters:
  - name: projectName
    description: The name of the new Next.js project.
    default: my-next-app
  - name: language
    description: "Initialize project with 'js' or 'ts'."
    default: "ts"
  - name: appRouter
    description: "Use the App Router (recommended)."
    default: true
  - name: srcDir
    description: "Use a 'src/' directory."
    default: true
  - name: tailwind
    description: "Initialize with Tailwind CSS."
    default: true
  - name: eslint
    description: "Initialize with ESLint."
    default: true
---

```bash
#!/bin/bash

# Default values for parameters if they are not set.
: "${projectName:=my-next-app}"
: "${language:=ts}"
: "${appRouter:=true}"
: "${srcDir:=true}"
: "${tailwind:=true}"
: "${eslint:=true}"

# Construct the command-line flags for create-next-app
FLAGS="--yes --use-npm"

if [ "$language" = "ts" ]; then
    FLAGS="$FLAGS --ts"
else
    FLAGS="$FLAGS --js"
fi

if [ "$appRouter" = "true" ]; then
    FLAGS="$FLAGS --app"
else
    FLAGS="$FLAGS --no-app"
fi

if [ "$srcDir" = "true" ]; then
    FLAGS="$FLAGS --src-dir"
else
    FLAGS="$FLAGS --no-src-dir"
fi

if [ "$tailwind" = "true" ]; then
    FLAGS="$FLAGS --tailwind"
else
    FLAGS="$FLAGS --no-tailwind"
fi

if [ "$eslint" = "true" ]; then
    FLAGS="$FLAGS --eslint"
else
    FLAGS="$FLAGS --no-eslint"
fi

# Run the official create-next-app with the constructed flags
echo "Running: npx create-next-app@latest "$projectName" $FLAGS"
npx create-next-app@latest "$projectName" $FLAGS

# Overwrite the default README with a simpler one for the context of the skill
cat <<EOF > "$projectName/README.md"
# $projectName

This Next.js project was created using the 'nextjs' skill.

## To run this project:

1.  Navigate into the project directory:
    '''bash
    cd $projectName
    '''
2.  Run the development server:
    '''bash
    npm run dev
    '''
3.  Open your browser to [http://localhost:3000](http://localhost:3000)

To learn more about Next.js, visit the [Next.js Documentation](https://nextjs.org/docs).
EOF

echo "✅ Successfully created Next.js project in '$projectName'"
```