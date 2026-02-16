
import tseslint from 'typescript-eslint';
import angular from 'angular-eslint';
import prettier from 'eslint-config-prettier';
import globals from 'globals';

export default [
  // 1. Global ignores
  {
    ignores: ['dist', 'node_modules', '*.cjs', '**/*.config.js'],
  },

  // 2. Recommended rules from typescript-eslint
  ...tseslint.configs.recommended,

  // 3. Angular-specific configuration
  {
    files: ['src/**/*.ts'],
    ...angular.configs.tsRecommended,
    languageOptions: {
      globals: {
        ...globals.browser,
      },
    },
    rules: {
        ...angular.configs.tsRecommended.rules,
    }
  },
  {
    files: ['src/**/*.html'],
    ...angular.configs.htmlRecommended,
    rules: {
        ...angular.configs.htmlRecommended.rules,
    }
  },

  // 4. Prettier config must be last to override other formatting rules.
  prettier,
];
