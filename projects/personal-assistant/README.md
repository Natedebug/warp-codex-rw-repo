# Personal Assistant (macOS-first)

Goal: Build a lightweight personal assistant focused on macOS that can run locally from the command line and integrate incrementally with native capabilities (say/tts, open apps, search, notes, reminders via AppleScript, Shortcuts).

## Quick start

- List commands:
  ```bash
  bash projects/personal-assistant/scripts/pa.sh help
  ```
- Try a few actions:
  ```bash
  bash projects/personal-assistant/scripts/pa.sh greet
  bash projects/personal-assistant/scripts/pa.sh speak "Welcome"
  bash projects/personal-assistant/scripts/pa.sh open "Notes"
  bash projects/personal-assistant/scripts/pa.sh note "Remember to stretch"
  bash projects/personal-assistant/scripts/pa.sh search "weather in SF"
  ```

Data is stored under `data/personal-assistant/` (notes, future state files). These are ignored by git to keep user data local.

## Commands (initial)

- `help` — show help
- `version` — print version
- `greet` — friendly greeting (and speak it when available)
- `speak <text>` — text-to-speech via macOS `say` when available
- `open <App Name>` — open a macOS application (e.g., "Notes", "Calendar"). Uses `open -Ra` to validate app; respects `PA_DRY_RUN_OPEN=1`.
- `note <text>` — append a timestamped note to `data/personal-assistant/notes.txt`
- `search <query>` — open default browser to a search for the query (supports engines via `PA_SEARCH_ENGINE=google|ddg|bing`; respects `PA_DRY_RUN_OPEN=1`)
- `status` — show a brief system status (battery, battery time when available, volume, Wi‑Fi network)

## Requirements

- macOS
- Bash (default on macOS) and common Unix tools
- Optional: `say`, `osascript`, `pmset`, `networksetup`, or the built-in `airport` CLI (present on macOS)

## Configuration

Set environment variables to customize behavior:

- `PA_DRY_RUN_OPEN=1` — print what would be opened (apps/URLs) without launching
- `PA_SEARCH_ENGINE` — `google` (default), `ddg`, or `bing`
- `PA_NOTES_FILE` — override path to notes file (primarily for tests)

## Roadmap (short)

- Reminders via AppleScript (with sensible permission handling)
- Calendar peek/add via AppleScript
- Shortcut integrations (call named Shortcuts)
- Voice trigger and dictation (Speech Recognition), opt-in
- Plugin model for custom tasks

See `docs/ROADMAP.md` for the longer backlog.
