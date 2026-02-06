import tseslint from 'typescript-eslint';
import vue from 'eslint-plugin-vue';
import prettier from 'eslint-config-prettier';

// The modern "flat config" is a plain JavaScript array.
export default [
  // 1. Global ignores
  {
    ignores: ['dist', 'node_modules', '*.cjs', '**/*.config.js'],
  },

  // 2. Recommended rules from typescript-eslint, applied to all .ts files
  ...tseslint.configs.recommended,

  // 3. Recommended rules for Vue
  ...vue.configs['flat/recommended'],

  // 4. Configure parser for TypeScript in .vue files and add custom rules
  {
    files: ['**/*.vue'],
    languageOptions: {
      parserOptions: {
        parser: tseslint.parser,
      },
    },
    rules: {
      'vue/require-default-prop': 'off',
    },
  },

  // 5. Prettier config must be last.
  // It turns off any formatting rules from other configs that might conflict.
  prettier,
];
