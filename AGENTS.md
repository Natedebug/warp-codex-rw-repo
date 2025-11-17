# AGENTS.md

Shared instructions for all coding agents (Codex CLI, Codex on the web, Warp, etc.) working in this repository.

## Project overview

- This repo is a minimal Bash-based utility and playground for AI-assisted coding.
- Core utilities live in `scripts/` and read/write data under `data/`.
- Additional experiments and projects live under `projects/` (for example, `projects/personal-assistant/`).
- All commands are assumed to be run from the repo root unless otherwise noted.

## Setup commands

- Install git hooks and check status:

  - `bash scripts/install-hooks.sh`
  - `bash scripts/status.sh`

- Run validation helpers:

  - `bash scripts/test.sh`
  - Project-specific tests (when present), for example:
    - `bash projects/personal-assistant/scripts/test.sh`

- Common tasks:

  - Read default input: `bash scripts/read.sh`
  - Write output: `bash scripts/write.sh`
  - Back up a file before editing: `bash scripts/backup.sh path/to/file`

## Roles of different agents

- **Codex CLI (primary interface)**  
  - Main “driver” for making changes and orchestrating work.  
  - Must:
    - Start sessions by running `bash scripts/status.sh` to understand pending tasks and current git state.
    - Respect branch and backup rules (see below).
    - Keep `WARP.md` and `CODEX.md` as source of truth for Warp/Codex-specific behavior.
    - When editing files, clearly describe what changed and why.

- **Warp (terminal + code editor)**  
  - Used for interactive editing and quick iterations.
  - Reads `WARP.md` and this `AGENTS.md` for project rules.
  - Must:
    - Never modify `WARP.md` directly.
    - Follow the same branch and backup rules as Codex CLI.
    - Log its work to `reports/warp-changes.md`.

- **Codex (web / cloud / GitHub code review)**  
  - Used for pull-request reviews and larger, cloud-based tasks.
  - When reviewing, read:
    - This `AGENTS.md`
    - `CODEX.md`
    - `WARP.md`
    - `CONTRIBUTING.md`
  - Respect the branch + PR workflow and treat `reports/warp-changes.md` and any PR description as key context.

## Branch and workflow rules

- Never commit directly to `main`.  
- For every task, create a feature branch:

  - `git checkout -b warp/<task-name>`

- Keep changes scoped:

  - Prefer to keep work inside a single area (for example, `projects/personal-assistant/`).
  - If a repo-wide change is needed, call that out explicitly and wait for confirmation.

- Before editing any file:

  - Run: `bash scripts/backup.sh path/to/file`
  - Work on the restored copy; the original should live under `backups/<date>/`.

- After each change set:

  - Append a new, most-recent-first entry to `reports/warp-changes.md` including:
    - Branch name
    - Files touched
    - Summary of what changed and why
    - Validation commands run (`bash scripts/test.sh`, project tests, etc.)
    - Results of those commands

- Always run at least:

  - `bash scripts/test.sh`

  And when relevant:

  - `bash projects/personal-assistant/scripts/test.sh`

  before asking for a review or opening a PR.

## Placeholder and style rules

- When you propose code snippets or new files that include placeholders for the user to fill in later, wrap placeholders in `!` markers, for example:

  - `!PROJECT_NAME!`
  - `!API_KEY!`
  - `!OUTPUT_PATH!`

- Inside `!…!` markers, use valid syntax for the surrounding language (no spaces where identifiers are not allowed).

- Bash scripting:

  - Prefer strict mode: `set -euo pipefail`.
  - Quote variables (`"$var"`) to avoid word-splitting.
  - Avoid non-portable Bash features unless clearly commented.

## Review guidelines

When reviewing changes (Codex CLI, Codex on the web, or any agent):

- Check that branch, backup, and change-log rules were followed.
- Confirm that the change:

  - Does not break `bash scripts/test.sh`.
  - Preserves existing behavior unless the user explicitly requested a change.
  - Includes clear comments when behavior changes significantly.

- Prefer small, focused changes over large refactors.
- When you find issues:

  - List them explicitly.
  - Explain why each is a problem.
  - Offer at least one concrete fix or alternative.

## PR instructions

- Feature branches should be named `warp/<task-name>`.
- PR description should include:

  - Summary of changes
  - Files touched
  - Validation commands and results
  - Any follow-up work (also mirrored in `reports/codex-requests.md` if used)

- Do not self-merge; wait for explicit approval from a human or a designated reviewer.
