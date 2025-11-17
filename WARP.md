# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Repository overview
- Minimal Bash-based utility repo: two scripts in `scripts/` interoperate via files under `data/`.
- Defaults assume commands are run from the repo root.
- Before editing any file, create a copy to modify and move the pristine original into a backup subfolder (for example, `backups/<date>/filename`).
- After finishing a change, record what was changed so Codex can review it (see `CODEX.md` for expectations).

Common commands
- Read default input
  - bash scripts/read.sh
- Read a specific file
  - bash scripts/read.sh path/to/file.txt
- Write content to a file (from stdin)
  - echo "some text" | bash scripts/write.sh data/output.txt
- Write content to a file (from args; quotes preserve spaces)
  - bash scripts/write.sh data/output.txt "some text with spaces"
- Backup a file before editing
  - bash scripts/backup.sh path/to/file
- Run lint + smoke tests
  - bash scripts/test.sh
- Optional linting (if installed; no repo config):
  - shellcheck scripts/*.sh
- Build/tests
  - bash scripts/test.sh (runs shellcheck when available and a read/write round-trip)

Architecture and flow
- scripts/read.sh
  - Strict Bash mode (`set -euo pipefail`).
  - Reads a file path arg or defaults to `data/input.txt`; exits with a helpful usage message if the file is missing; outputs file contents to stdout.
- scripts/write.sh
  - Strict Bash mode; ensures parent directory exists for the output path.
  - Output path defaults to `data/output.txt`.
  - Content source priority: CLI args (joined with spaces), else stdin (required when no args); prints a summary with the number of bytes written.

Notes and caveats
- Paths are interpreted relative to the current working directory; run commands from the repo root or pass absolute paths.
- Quoting content when using the args form of `write.sh` prevents word splitting.
- Follow the collaboration workflow documented in `README.md` and `CODEX.md` so Warp and Codex stay in sync.

Important references
- `data/README.md`: documents the default input (`data/input.txt`) and typical output naming (`data/output.txt`).
- `reports/warp-changes.md`: append an entry for each change set so Codex knows what to review (use the template at the top of the file).
