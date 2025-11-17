# Roadmap — Personal Assistant (macOS-first)

Scope: Local-first assistant that automates common tasks on macOS. Favor privacy, explicit permissions, and incremental integrations.

## Milestone 0 — CLI foundation (this PR)
- Basic commands: help, greet, speak, open, note, search, status
- Data dir under `data/personal-assistant/` (gitignored)
- Smoke tests

## Milestone 1 — AppleScript integrations
- Reminders: add/list basic reminders to a default list
- Calendar: list today's events; add a quick event
- Notes: create a new note in the Notes app
- Shortcuts: run a named Shortcut with args

## Milestone 2 — Extensibility
- Plugin system (simple shell/Python hooks under `plugins/`)
- Config file (`pa.conf`) for defaults (e.g., default reminder list)

## Milestone 3 — Voice and context
- Voice activation (push-to-talk or hotkey; macOS dictation APIs or external)
- Local LLM integration (opt-in) for natural-language intents → commands

## Milestone 4 — Packaging
- Optional installer/symlink script
- Homebrew tap (future)

## Milestone X — Ideas backlog
- Window management helpers
- Mail triage helpers
- Filesystem cleanup routines
- Focus/Do Not Disturb toggles (as permissions allow)
