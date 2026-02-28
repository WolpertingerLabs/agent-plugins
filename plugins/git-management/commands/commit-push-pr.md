---
name: commit-push-pr
description: Run the full lint, commit, push, and PR pipeline. Stop immediately if any step fails.
argument-hint: "[install-deps]"
---

## Arguments

`$ARGUMENTS`

- Pass arguments through to any lint commands that are invoked (e.g. `install-deps`).

## Step 1 — Run lint/build/format via code-management (if available)

Check whether the **code-management** plugin is installed by looking for a `/lint-nodejs` slash command (or any `code-management:lint-*` commands).

- If the **code-management** plugin is **not** installed, skip this step entirely and go straight to step 2 (Git commit).

- If the **code-management** plugin **is** installed, detect the project type and run the matching lint command:

  1. **Node.js project** — if a `package.json` exists in the repository root, run:
     ```
     /code-management:lint-nodejs $ARGUMENTS
     ```
     Wait for it to complete. If it fails, stop and fix before continuing.

  2. *(Future project types would be detected here in the same fashion.)*

  If the project does not match any known type, skip this step.

## Step 2 — Git commit

Stage all changes (including any formatting/lint fixes from above) and commit with a descriptive message summarizing what changed:

```
git add -A
git commit -m "<descriptive message>"
```

## Step 3 — Detect branch and worktree context

Before pushing, determine the current context:

- Check if on a **non-primary branch** (i.e. not `main` or `master`):
  ```
  git branch --show-current
  ```
- Check if in a **git worktree** (not the main working tree):
  ```
  git rev-parse --git-common-dir
  ```
  If the output of `git rev-parse --git-common-dir` differs from `git rev-parse --git-dir`, you are in a worktree.

## Step 4 — Git push

```
git push
```

If on a non-primary branch and pushing for the first time, use `git push -u origin <branch>`.

## Step 5 — Create PR (only if on a non-primary branch)

```
gh pr create --fill
```

If a PR already exists for the branch, skip this step (check with `gh pr view` first).

## Important

- If any step fails, **stop immediately**, diagnose the issue, fix it, and restart from the failed step.
- The commit message should accurately describe the changes — do NOT use a generic message like "save and reboot".
