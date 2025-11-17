# warp-codex-rw-repo

A minimal repository that both Warp and Codex CLI (or any CLI) can read from and write to. It provides simple, dependency-free shell scripts for reading a file and writing content to a file.

## Structure

- `scripts/read.sh` — Prints the contents of a file (defaults to `data/input.txt`).
- `scripts/write.sh` — Writes content (from stdin or arguments) to a file (defaults to `data/output.txt`).
- `scripts/backup.sh` — Moves the pristine original of a file into `backups/` and restores a working copy in place for editing.
- `data/input.txt` — Example input file.

## Projects

- Personal Assistant (macOS-first): `projects/personal-assistant/`
  - Entry point: `bash projects/personal-assistant/scripts/pa.sh help`

## Requirements

- macOS default shell (bash/zsh) is sufficient; scripts use `bash` and common Unix tools.

## Usage

Read a file (defaults to `data/input.txt`):

```bash
./scripts/read.sh               # reads data/input.txt
./scripts/read.sh data/input.txt
```

Write content from stdin:

```bash
echo "hello from stdin" | ./scripts/write.sh               # writes to data/output.txt
printf "line 1\nline 2\n" | ./scripts/write.sh data/output.txt
```

Write content from arguments:

```bash
./scripts/write.sh data/output.txt "Hello from args"
```

Result is written to the chosen output path; parent directories are created as needed.

Check repo status (pending requests, change log summary, git state):

```bash
bash scripts/status.sh
```

## Validation

Run the helper script to lint the Bash utilities (when `shellcheck` is available) and perform a read/write smoke test:

```bash
bash scripts/test.sh
```

## Collaboration workflow

- Read `WARP.md` and `CODEX.md` for role-specific guidance.
- Always duplicate a file before editing; move the untouched original into a subfolder (for example, `backups/<date>/filename`) so it can be restored later.
- Use `scripts/backup.sh path/to/file` to automate creating the backup and resetting a working copy.
- Warp documents its modifications by adding entries to `reports/warp-changes.md` so Codex can review and summarize them for the user.
- Codex reviews Warp's changes, explains them to the user, and flags issues with suggested fixes.

## Notes

- Outputs matching `data/output*` and everything in `backups/` are ignored by git (see `.gitignore`).
- No initial commit is created; initialize and commit as you prefer.
