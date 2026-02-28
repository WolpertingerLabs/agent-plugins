---
name: lint-nodejs
description: Install dependencies, build, lint, and format a Node.js project. Only runs steps whose scripts are defined in package.json.
argument-hint: "[skip-install]"
---

## Arguments

`$ARGUMENTS`

- If the arguments contain `skip-install`, **skip step 1** (Install dev dependencies). Otherwise, run step 1 by default.

## Precondition

Verify this is a **Node.js project** by checking for a `package.json` in the repository root.

- If `package.json` **does not exist**, inform the caller that this is not a Node.js project and stop.
- If `package.json` **exists**, proceed with the steps below. For each step, verify the relevant script is defined in `package.json` before running it. Skip any step whose script is not defined.

## Steps

1. **Install dev dependencies** (runs by default; skip if `skip-install` is passed):

   ```
   npm install --include=dev
   ```

   Stop and fix any installation errors before continuing.

2. **Build** the project (only if a `"build"` script exists in `package.json`):

   ```
   npm run build
   ```

   Stop and fix any build errors before continuing.

3. **Lint** all files (only if a `"lint:all:fix"` script exists in `package.json`):

   ```
   npm run lint:all:fix
   ```

   Stop and fix any lint errors that could not be auto-fixed.

4. **Prettier** — format only touched (uncommitted) files (only if a `"prettier"` script exists in `package.json`):

   ```
   npm run prettier
   ```

## Important

- If any step fails, **stop immediately**, diagnose the issue, fix it, and restart from the failed step.
- Only run steps whose corresponding npm scripts actually exist in `package.json`. Do not assume any script is present.
