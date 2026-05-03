import fs from 'node:fs';
import path from 'node:path';

// --- Configuration ---
const packageJsonPath = path.join(process.cwd(), 'package.json');

const scriptsToAdd = {
  lint: 'eslint .',
  format: 'prettier . --write',
};

// These versions are compatible with ESLint v9
const devDependenciesToAdd = {
  '@typescript-eslint/eslint-plugin': '^8.0.0-alpha.44',
  '@typescript-eslint/parser': '^8.0.0-alpha.44',
  eslint: '^9.4.0',
  'eslint-config-prettier': '^9.1.0',
  'eslint-plugin-lit': '^1.13.0',
  'eslint-plugin-wc': '^2.1.0',
  prettier: '^3.3.1',
  'typescript-eslint': '^8.0.0-alpha.44', // Required for the new config builder
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
  // Read package.json
  const packageJsonContent = fs.readFileSync(packageJsonPath, 'utf8');
  const packageJson = JSON.parse(packageJsonContent);

  // Add scripts
  packageJson.scripts = { ...packageJson.scripts, ...scriptsToAdd };

  // Add devDependencies
  packageJson.devDependencies = {
    ...packageJson.devDependencies,
    ...devDependenciesToAdd,
  };

  // Add Prettier config
  packageJson.prettier = prettierConfig;

  // Write the updated package.json back to the file
  const updatedPackageJsonContent = JSON.stringify(packageJson, null, 2);
  fs.writeFileSync(packageJsonPath, updatedPackageJsonContent);

  console.log('Successfully updated package.json with ESLint v9 compatible dependencies!');
} catch (error) {
  console.error('Error updating package.json:', error);
  process.exit(1);
}
