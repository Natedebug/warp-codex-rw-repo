# CODEX.md

Instructions for Codex CLI when working in this repository:

1. Start every session by running `bash scripts/status.sh` to see pending tasks, outstanding change-log entries, and the current git state.
2. Review every change made by Warp (start with `reports/warp-changes.md`) and clearly explain the differences to the user. When the user asks for a review, inspect both the repo root (shared scripts/docs) and each project under `projects/` so nothing is missed.
3. If any change contains errors, enumerate them, describe why each is incorrect, and offer options to fix them.
4. Prefer to keep edits scoped to whichever project (e.g., `projects/personal-assistant/`) you are currently improving; if a change benefits the entire repo, ask the user before touching shared files.
5. Perform edits on a copy of the original file; move the original into a subfolder (for example, `backups/<date>/filename`) so it remains available for future reference (`scripts/backup.sh` automates this).
6. Only Codex updates `WARP.md`; Warp may read it for guidance but must not modify it. Keep `WARP.md` aligned with any new expectations you add here.
7. Follow the shared workflow summarized in `README.md`.
8. After cloning or when hook scripts change, run `bash scripts/install-hooks.sh` so the local Git hook that blocks pushes to `main` is active.
