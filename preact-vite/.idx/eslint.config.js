import tseslint from 'typescript-eslint';
import eslintReact from '@eslint-react/eslint-plugin';
import prettier from 'eslint-config-prettier';
import globals from 'globals';

export default [
  // 1. Global ignores
  {
    ignores: ['dist', 'node_modules', '*.cjs', '**/*.config.js'],
  },

  // 2. Recommended rules from typescript-eslint
  ...tseslint.configs.recommended,

  // 3. Modern ESLint React configuration for Preact
  {
    files: ['src/**/*.{js,jsx,ts,tsx}'],
    ...eslintReact.configs.recommended,
    languageOptions: {
      globals: {
        ...globals.browser,
      },
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
    rules: {
      ...eslintReact.configs.recommended.rules,
      // Preact-specific overrides
      '@eslint-react/react-in-jsx-scope': 'off', // Not needed with modern JSX transform
      '@eslint-react/dom/no-unsafe-target-blank': 'warn',
    },
    settings: {
      react: {
        version: 'detect',
        pragma: 'h', // Use 'h' for Preact
        pragmaFrag: 'Fragment', // Use 'Fragment' for Preact
      },
    },
  },

  // 4. Prettier config must be last to override other formatting rules.
  prettier,
];
