import tseslint from 'typescript-eslint';
import lit from 'eslint-plugin-lit';
import wc from 'eslint-plugin-wc';
import prettier from 'eslint-config-prettier';

// The modern "flat config" is a plain JavaScript array.
export default [
  // 1. Global ignores
  {
    ignores: ['dist', 'node_modules', '*.cjs', '**/*.config.js'],
  },

  // 2. Recommended rules from typescript-eslint, applied to all .ts files
  ...tseslint.configs.recommended,

  // 3. Our custom rules for Lit and Web Components
  {
    files: ['src/**/*.js', 'src/**/*.ts'],
    plugins: {
      lit,
      wc,
    },
    rules: {
      // Start with the recommended rules for lit and wc
      ...lit.configs.recommended.rules,
      ...wc.configs.recommended.rules,

      // You can add custom rule overrides here if needed
      // For example: 'lit/no-legacy-template-syntax': 'off',
    },
  },

  // 4. Prettier config must be last.
  // It turns off any formatting rules from other configs that might conflict.
  prettier,
];
