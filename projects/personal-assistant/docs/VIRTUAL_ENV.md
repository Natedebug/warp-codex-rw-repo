# Simulated macOS test environment (12.6.1, MacBook Pro M1 Pro)

Use this virtual test environment when you need macOS-style behaviors on a non-macOS host. It builds stub binaries that mimic macOS 12.6.1 running on a MacBook Pro M1 Pro so you can exercise the CLI and tests without real macOS dependencies.

## Setup

1. Build the stubbed environment (idempotent):
   ```bash
   bash projects/personal-assistant/scripts/create-macos-sim-env.sh
   ```
2. Activate the simulation for your shell session:
   ```bash
   source projects/personal-assistant/.macos-12.6.1-sim/activate
   ```
3. Run validations with the simulated PATH:
   ```bash
   bash scripts/test.sh
   bash projects/personal-assistant/scripts/test.sh
   bash projects/personal-assistant/scripts/pa.sh status
   ```
4. Deactivate when finished:
   ```bash
   source projects/personal-assistant/.macos-12.6.1-sim/deactivate
   ```

## What the simulation provides

- `pmset -g batt` prints a Monterey-style battery line (e.g., `86% discharging; 3:44 remaining`).
- `osascript -e 'output volume of (get volume settings)'` returns `42`; app ID lookups succeed for any name.
- `say` and `open` echo their inputs so commands stay side-effect free.
- `networksetup -listallhardwareports` exposes a Wi‑Fi interface `en0`; `-getairportnetwork en0` reports `TestWifi`.
- Activation exports metadata for reference: `PA_SIM_MAC_MODEL=MacBookPro18,3`, `PA_SIM_MACOS_VERSION=12.6.1`, `PA_DRY_RUN_OPEN=1`.

## Verification checklist

- After activation, `which pmset` and `which osascript` point to `.macos-12.6.1-sim/bin`.
- `bash projects/personal-assistant/scripts/pa.sh status` prints battery, volume `42`, and Wi‑Fi `TestWifi` without errors.
- Both test scripts complete successfully while the simulation is active.
