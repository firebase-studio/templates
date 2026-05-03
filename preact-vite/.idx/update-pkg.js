import fs from 'node:fs';
import path from 'node:path';

// --- Configuration ---
const packageJsonPath = path.join(process.cwd(), 'package.json');

const scriptsToAdd = {
  lint: 'eslint .',
  format: 'prettier . --write',
};

// Modern dev dependencies for Preact, ESLint v9+, TypeScript, and Prettier
const devDependenciesToAdd = {
  '@eslint-react/eslint-plugin': 'latest', // Modern, flat-config compatible React plugin
  eslint: '^9.5.0',
  'eslint-config-prettier': '^9.1.0',
  globals: '^15.4.0',
  prettier: '^3.3.2',
  'typescript-eslint': 'latest', // Use latest for best compatibility
};

const prettierConfig = {
  arrowParens: 'always',
  bracketSpacing: true,
  htmlWhitespaceSensitivity: 'css',
  insertPragma: false,
  bracketSameLine: false,
  jsxSingleQuote: false,
  printWidth: 80,
  proseWrap: 'preserve',
  quoteProps: 'as-needed',
  requirePragma: false,
  semi: true,
  singleQuote: true,
  tabWidth: 2,
  trailingComma: 'es5',
  useTabs: false,
};

// --- Script Logic ---
try {
  const packageJsonContent = fs.readFileSync(packageJsonPath, 'utf8');
  const packageJson = JSON.parse(packageJsonContent);

  packageJson.scripts = { ...packageJson.scripts, ...scriptsToAdd };
  packageJson.devDependencies = {
    ...packageJson.devDependencies,
    ...devDependenciesToAdd,
  };
  packageJson.prettier = prettierConfig;

  const updatedPackageJsonContent = JSON.stringify(packageJson, null, 2);
  fs.writeFileSync(packageJsonPath, updatedPackageJsonContent);

  console.log('Successfully updated package.json with modern ESLint and Prettier configs!');
} catch (error) {
  console.error('Error updating package.json:', error);
  process.exit(1);
}
