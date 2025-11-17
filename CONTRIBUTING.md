# Contributing

This repository uses a branch + pull request workflow. Direct pushes to `main` are blocked by a local Git hook.

## Quick policy
- Never push directly to `main`.
- Create a feature branch per task: `warp/<task-name>`.
- Open a pull request targeting `main`.
- Do not self-merge. Leave PRs open for review by others (the user and/or Codex). Merge only after explicit approval.

## Setup
- Install the local hooks (blocks direct pushes to protected branches):
  ```bash
  bash scripts/install-hooks.sh
  ```
- See repo status, pending requests, and the latest change log entry:
  ```bash
  bash scripts/status.sh
  ```

## Working model
- Scope: keep changes within the active project (e.g., `projects/personal-assistant/`) unless a repo-wide change is explicitly approved.
- Backups: before editing, back up the file and restore a working copy:
  ```bash
  bash scripts/backup.sh path/to/file
  ```
- Change log: after each change set, append an entry to `reports/warp-changes.md` (newest entries at the top) with files touched, summary, and validation steps.
- Validation: run tests before opening a PR:
  ```bash
  bash scripts/test.sh
  # and project-specific tests
  bash projects/personal-assistant/scripts/test.sh
  ```
- Linting: if available, run `shellcheck` against `scripts/*.sh` and project scripts.

## PR expectations
- Keep PRs focused and small where possible.
- Include a clear summary of what changed and why, plus validation steps and their results.
- Reference any follow-up work in `reports/codex-requests.md` if needed.
