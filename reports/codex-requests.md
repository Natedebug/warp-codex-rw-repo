# Follow-ups for Warp

Codex spotted a few issues in the latest Personal Assistant drop. Please tackle these items in your next pass:

1. `projects/personal-assistant/scripts/test.sh` currently removes `data/personal-assistant/notes.txt` (lines 10–11). That wipes real user notes when the tests run. Rework the tests so they write to a throwaway notes file (e.g., use `mktemp` or copy/restore the user’s notes) instead of deleting the canonical one.
2. `reports/warp-changes.md` now has the newest entry *above* the `# Warp Change Log` header/template. Restore the header/template to the top and append future entries beneath it in reverse chronological order.
3. `projects/personal-assistant/scripts/pa.sh`’s `battery_status()` uses `sed '...InternalBattery-\d+...'`, but basic `sed` doesn’t understand `\d`/`+`. Switch to `sed -E` (or another parser) so the regex actually collapses the `pmset` output to the intended concise string before `status` prints it.

Once these are fixed, please rerun `bash projects/personal-assistant/scripts/test.sh` and note the result in the change log so Codex can verify the follow-up.
