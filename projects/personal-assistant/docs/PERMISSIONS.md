# Personal Assistant permissions (macOS)

This project aims to be macOS-first and transparent about what it can read and write. The CLI enforces explicit read/write settings so you can grant or withhold access per your comfort level.

## Read access

- Controlled by `PA_ALLOW_READ` (defaults to `1`).
- Commands that inspect the filesystem call `ensure_readable_path` and will refuse to run when reads are disabled.
- Reads use absolute, expanded paths to avoid confusion with symlinks or `~` shortcuts.

## Write access

- Controlled by `PA_ALLOW_WRITE` and `PA_ALLOWED_WRITE_DIRS`.
- Writes are **scoped** to a colon-separated list of directories defined in `PA_ALLOWED_WRITE_DIRS`. Anything outside those directories is blocked.
- Prompts are opt-in via `PA_CONFIRM_WRITE=1` (enabled in `config/permissions.env.sample`) to ask for a one-time confirmation before writing to a target path.
- The default notes file under `data/personal-assistant/` stays within the allowed directories so tests and safe note-taking continue to work.

## Configuration steps (macOS Terminal)

1. Copy the sample permissions file and edit it to match your allowed paths:
   ```bash
   cd /workspace/warp-codex-rw-repo/projects/personal-assistant
   cp config/permissions.env.sample config/permissions.env
   open -e config/permissions.env
   ```
2. Update `PA_ALLOWED_WRITE_DIRS` with the directories you want to permit (use `:` as a separator).
3. Export the configuration before running the assistant (or add to your shell profile):
   ```bash
   set -a
   source config/permissions.env
   set +a
   ```
4. Verify the configuration is loaded:
   ```bash
   env | grep ^PA_
   ```

## Commands that honor permissions

- `pa read <path>` — reads a file after verifying `PA_ALLOW_READ`.
- `pa write <path> <text>` — appends text to a file only when the target is within `PA_ALLOWED_WRITE_DIRS` and writes are enabled.
- Existing commands (e.g., `note`) continue writing inside the default data directory, keeping them within the allowed scope.
