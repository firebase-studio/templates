const fs = require('fs');
const path = require('path');

const packageJsonPath = path.join(process.cwd(), 'package.json');
const packageJson = require(packageJsonPath);

// Add lint and format scripts
packageJson.scripts = {
  ...packageJson.scripts,
  "lint": "eslint .",
  "format": "prettier --write ."
};

// Add new dev dependencies
packageJson.devDependencies = {
  ...packageJson.devDependencies,
  "@eslint/js": "^9.2.0",
  "eslint": "^9.2.0",
  "eslint-config-prettier": "^9.1.0",
  "globals": "^15.2.0",
  "prettier": "^3.2.5",
};

// Write the updated package.json back to the file
fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));

console.log('Successfully updated package.json with ESLint and Prettier dependencies and scripts.');
