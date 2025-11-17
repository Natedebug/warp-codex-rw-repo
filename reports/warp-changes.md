# Warp Change Log

Warp should append a new section for every batch of edits so Codex can review them easily.

Template:

```
## YYYY-MM-DD HH:MM TZ — short title
- Files touched: path1, path2
- Summary: brief explanation of what was changed and why
- Validation: commands run (if any) and their outcomes
```

Keep the newest entries at the top for quick scanning.

## 2025-11-17 12:28 UTC — Add permission-aware filesystem commands
- Files touched: projects/personal-assistant/scripts/pa.sh, projects/personal-assistant/src/permissions.sh, projects/personal-assistant/config/permissions.env.sample, projects/personal-assistant/docs/PERMISSIONS.md, projects/personal-assistant/README.md
- Summary: Added a permissions module and CLI commands for controlled read/write operations, with sample macOS configuration and documentation. Notes now respect write-allowance settings, and new read/write commands gate access based on user-defined directories.
- Validation: `bash scripts/test.sh`; `bash projects/personal-assistant/scripts/test.sh`

## 2025-11-17 10:40 UTC — Fix ShellCheck lint in install-hooks.sh
- Files touched: scripts/install-hooks.sh
- Summary: Resolved ShellCheck SC2043 by removing a single-item for-loop; the script now sets the hook explicitly and runs once. Backed up the original before editing.
- Validation: Installed ShellCheck via Homebrew (0.11.0); `bash scripts/test.sh` passed with lint enabled and the read/write round-trip succeeded.

## 2025-11-17 10:57 UTC — Clarify PA README configuration section
- Files touched: projects/personal-assistant/README.md
- Summary: Removed reference to `pa.conf` since the script does not source a config file yet; documented env vars only to avoid overstating features.
- Validation: Docs-only change.

## 2025-11-17 05:50 UTC — Add CONTRIBUTING; document PR policy in README
- Files touched: CONTRIBUTING.md, README.md
- Summary: Added CONTRIBUTING.md describing branch/PR policy (no direct pushes to main; PRs required and left open for review), setup (install hooks, status), workflow (backup, change log, validation). Updated README to link to CONTRIBUTING and summarize the policy.
- Validation: Docs-only change.

## 2025-11-17 04:11 UTC — Address Codex requests: safer tests, battery parser, restore change log header
- Files touched: projects/personal-assistant/scripts/pa.sh, projects/personal-assistant/scripts/test.sh, reports/warp-changes.md
- Summary: Tests now use a temporary notes file (no data loss), `battery_status()` uses a robust parser for pmset output, and the change log header/template is restored to the top with entries below it.
- Validation: `bash projects/personal-assistant/scripts/test.sh` passed locally; `bash scripts/status.sh` no longer flags these items.

## 2025-11-17 03:16 UTC — Scaffold Personal Assistant project (macOS)
- Files touched: projects/personal-assistant/README.md, projects/personal-assistant/scripts/pa.sh, projects/personal-assistant/scripts/test.sh, projects/personal-assistant/docs/ROADMAP.md, data/personal-assistant/.gitkeep, .gitignore, README.md
- Summary: Added a new macOS-first Personal Assistant project with a CLI (`pa.sh`), initial commands (greet, speak, open, note, search, status), tests, and a roadmap. Updated `.gitignore` to keep user data local and linked the project from the root README.
- Validation: `bash projects/personal-assistant/scripts/test.sh` passed; root `bash scripts/test.sh` still passes.
