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

## 2025-11-17 06:36 UTC — Avoid opening apps during validation
- Files touched: projects/personal-assistant/scripts/pa.sh
- Summary: Updated `open` validation to use `osascript`/filesystem checks so dry runs no longer launch or reveal apps while still rejecting unknown names.
- Validation: Manual review; personal-assistant tests still pass (see Codex run).

## 2025-11-17 05:50 UTC — Add CONTRIBUTING; document PR policy in README
- Files touched: CONTRIBUTING.md, README.md
- Summary: Added CONTRIBUTING.md describing branch/PR policy (no direct pushes to main; PRs required and left open for review), setup (install hooks, status), workflow (backup, change log, validation). Updated README to link to CONTRIBUTING and summarize the policy.
- Validation: Docs-only change.

## 2025-11-17 05:36 UTC — PA must-fix: robust URL encode, safe app open, status polish; docs/tests updated
- Files touched: projects/personal-assistant/scripts/pa.sh, projects/personal-assistant/scripts/test.sh, projects/personal-assistant/README.md
- Summary: Replaced brittle URL encoding with Python fallback and POSIX-safe loop; validated apps before opening and added PA_DRY_RUN_OPEN for tests; enhanced status with Wi‑Fi SSID and battery time when available; documented config and updated tests to use dry-run where needed.
- Validation: `bash projects/personal-assistant/scripts/test.sh` passed locally.

## 2025-11-17 04:11 UTC — Address Codex requests: safer tests, battery parser, restore change log header
- Files touched: projects/personal-assistant/scripts/pa.sh, projects/personal-assistant/scripts/test.sh, reports/warp-changes.md
- Summary: Tests now use a temporary notes file (no data loss), `battery_status()` uses a robust parser for pmset output, and the change log header/template is restored to the top with entries below it.
- Validation: `bash projects/personal-assistant/scripts/test.sh` passed locally; `bash scripts/status.sh` no longer flags these items.

## 2025-11-17 03:16 UTC — Scaffold Personal Assistant project (macOS)
- Files touched: projects/personal-assistant/README.md, projects/personal-assistant/scripts/pa.sh, projects/personal-assistant/scripts/test.sh, projects/personal-assistant/docs/ROADMAP.md, data/personal-assistant/.gitkeep, .gitignore, README.md
- Summary: Added a new macOS-first Personal Assistant project with a CLI (`pa.sh`), initial commands (greet, speak, open, note, search, status), tests, and a roadmap. Updated `.gitignore` to keep user data local and linked the project from the root README.
- Validation: `bash projects/personal-assistant/scripts/test.sh` passed; root `bash scripts/test.sh` still passes.
