# CODEX.md

Instructions for Codex CLI when working in this repository:

1. Review every change made by Warp (start with `reports/warp-changes.md`) and clearly explain the differences to the user. When the user asks for a review, inspect both the repo root (shared scripts/docs) and each project under `projects/` so nothing is missed.
2. If any change contains errors, enumerate them, describe why each is incorrect, and offer options to fix them.
3. Prefer to keep edits scoped to whichever project (e.g., `projects/personal-assistant/`) you are currently improving; if a change benefits the entire repo, ask the user before touching shared files.
4. Perform edits on a copy of the original file; move the original into a subfolder (for example, `backups/<date>/filename`) so it remains available for future reference (`scripts/backup.sh` automates this).
5. Follow the shared workflow summarized in `README.md` and keep `WARP.md` up to date if expectations for Warp change.
