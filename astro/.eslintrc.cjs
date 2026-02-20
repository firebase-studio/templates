module.exports = [
  "eslint:recommended",
  ...require("@typescript-eslint/eslint-plugin").configs.recommended,
  ...require("eslint-plugin-astro").configs.recommended,
  "prettier",
];
