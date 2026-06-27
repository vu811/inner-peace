# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

**Inner Peace** is a Garmin Connect IQ watch application written in **Monkey C**.

The app monitors the user's heart rate and, when it detects an elevated heart rate while the user appears inactive, surfaces calming guidance such as breathing exercises or mindfulness prompts. It is a wellness companion and must never make medical diagnoses or clinical claims.

**Current status:** MVP implemented. Heart rate monitoring, stress detection, positive message repository, scheduled messages (08:00 / 12:30 / 16:30), and prompt UI are all wired and functional.

## Repository Layout

```
manifest.xml          # App manifest (entry point, permissions, target devices)
source/               # Monkey C source files (.mc)
resources/
  layouts/            # XML view layouts
  strings/            # Localised string resources
docs/                 # Design and architecture documents
```

## Development Principles

- Keep the architecture modular — see `docs/architecture.md` for the proposed component breakdown.
- Prefer readable code over clever code.
- Minimize memory usage; avoid unnecessary allocations on the watch heap.
- Follow Garmin best practices (event-driven sensor updates, proper lifecycle handling).
- Separate business logic from UI — views contain no logic; logic contains no drawing code.

## Build & Validate Workflow

After making any source code change, always validate by building from the CLI before reporting success:

```bash
SDK="$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/bin"
"$SDK/monkeyc" -o bin/innerpeace.prg -f monkey.jungle -y developer_key.der -d venusq2m -w
```

- If the build fails, read the error, fix it, and rebuild — repeat until `BUILD SUCCESSFUL`.
- Only report a change as done once the build passes.
- To run on the simulator after a successful build:
  ```bash
  open "$SDK/ConnectIQ.app"   # launch simulator (once)
  "$SDK/monkeydo" bin/innerpeace.prg venusq2m &   # deploy in background
  ```

## AI Coding Guidelines

- **Never invent Garmin APIs.** Every API call must exist in the Connect IQ SDK documentation.
- Verify API usage against the SDK docs before writing code.
- Prefer event-driven sensor updates (`Sensor.registerSensorDataListener`) over polling.
- Keep functions focused and small.
- Add a comment when the reason behind a decision is non-obvious (not what the code does, but why).
- Do not add features, refactoring, or abstractions beyond what the current task requires.

## Architecture

See `docs/architecture.md` for the full description. Summary:

| Component | Role |
|---|---|
| `InnerPeaceApp` | App entry point, delegates lifecycle to `AppController` |
| `AppController` | Wires all components, routes callbacks |
| `HeartRateMonitor` | Sensor subscription via `Sensor.registerSensorDataListener` |
| `StressDetector` | Elevated HR + inactivity heuristic with sustain window and cooldown |
| `PositiveMessageRepository` | Four message pools (stress / morning / midday / evening) |
| `MessageScheduler` | 60-second timer, fires at 08:00 / 12:30 / 16:30 |
| `PromptPresenter` | Pushes `PromptView` onto the stack; guards against duplicate overlays |
| `PromptView` | Draws word-wrapped message on black background |
| `PromptDelegate` | Handles back-button dismiss |

Deferred to future releases: `SettingsManager` (user-configurable thresholds), guided breathing animations, haptic feedback.

Update this file and `docs/architecture.md` when the architecture changes.
