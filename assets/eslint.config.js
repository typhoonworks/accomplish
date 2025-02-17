import eslintPluginSvelte from "eslint-plugin-svelte";
import svelteParser from "svelte-eslint-parser";
import eslintPluginPrettier from "eslint-plugin-prettier";
import eslintPluginTS from "@typescript-eslint/eslint-plugin";
import tsParser from "@typescript-eslint/parser";

/** @type {import("eslint").Linter.Config[]} */
export default [
  {
    files: ["**/*.js", "**/*.ts", "**/*.svelte"],
    languageOptions: {
      parser: tsParser,
    },
    plugins: {
      "@typescript-eslint": eslintPluginTS,
      svelte: eslintPluginSvelte,
      prettier: eslintPluginPrettier,
    },
    rules: {
      "prettier/prettier": [
        "error",
        {
          semi: true,
          singleQuote: false,
          trailingComma: "all",
        },
      ],
      "@typescript-eslint/no-unused-vars": [
        "warn",
        { argsIgnorePattern: "^_", varsIgnorePattern: "^_" },
      ],
      "no-console": "warn",
      "no-debugger": "warn",
    },
  },
  {
    files: ["**/*.svelte"],
    languageOptions: {
      parser: svelteParser,
      parserOptions: {
        parser: tsParser,
        extraFileExtensions: [".svelte"],
      },
    },
    plugins: {
      svelte: eslintPluginSvelte,
    },
    processor: eslintPluginSvelte.processors.svelte,
  },
];
