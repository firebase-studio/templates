import tseslint from 'typescript-eslint';
import react from 'eslint-plugin-react';
import prettier from 'eslint-config-prettier';

// The modern "flat config" is a plain JavaScript array.
export default [
  // 1. Global ignores
  {
    ignores: ['dist', 'node_modules', '*.cjs', '**/*.config.js'],
  },

  // 2. Recommended rules from typescript-eslint, applied to all .ts files
  ...tseslint.configs.recommended,

  // 3. Our custom rules for React
  {
    files: ['src/**/*.js', 'src/**/*.jsx', 'src/**/*.ts', 'src/**/*.tsx'],
    plugins: {
      react,
    },
    rules: {
      // Start with the recommended rules for react
      ...react.configs.recommended.rules,
      ...react.configs['jsx-runtime'].rules,

      // You can add custom rule overrides here if needed
    },
    settings: {
        react: {
            version: 'detect',
        },
    }
  },

  // 4. Prettier config must be last.
  // It turns off any formatting rules from other configs that might conflict.
  prettier
];