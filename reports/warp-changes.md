## 2025-11-17 03:16 UTC — Scaffold Personal Assistant project (macOS)
- Files touched: projects/personal-assistant/README.md, projects/personal-assistant/scripts/pa.sh, projects/personal-assistant/scripts/test.sh, projects/personal-assistant/docs/ROADMAP.md, data/personal-assistant/.gitkeep, .gitignore, README.md
- Summary: Added a new macOS-first Personal Assistant project with a CLI (`pa.sh`), initial commands (greet, speak, open, note, search, status), tests, and a roadmap. Updated `.gitignore` to keep user data local and linked the project from the root README.
- Validation: `bash projects/personal-assistant/scripts/test.sh` passed; root `bash scripts/test.sh` still passes.

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
