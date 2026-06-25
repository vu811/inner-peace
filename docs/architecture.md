# Architecture

## Project Goals

Inner Peace is a Garmin Connect IQ watch application that passively monitors the wearer's heart rate. When it detects an elevated heart rate while the wearer appears to be at rest (low movement), it surfaces calming guidance — breathing exercises, mindfulness prompts — to help reduce stress. The app is a wellness companion; it must never make medical diagnoses or clinical claims.

## Proposed Architecture

```
InnerPeaceApp          (Application.AppBase)
│
├── HeartRateMonitor   (sensor layer)
├── ThresholdDetector  (business logic)
├── CalmPromptService  (content layer)
├── SettingsManager    (persistence)
└── BreathingView      (UI)
```

### Component Responsibilities

| Component | Responsibility |
|---|---|
| **InnerPeaceApp** | Entry point. Owns lifecycle (`onStart` / `onStop`). Wires up components. |
| **HeartRateMonitor** | Subscribes to `Sensor.HeartRate` events. Emits heart rate readings to listeners. Handles sensor availability checks. |
| **ThresholdDetector** | Receives heart rate readings. Compares against a configurable threshold. Applies inactivity heuristics (accelerometer data or activity state) before triggering an alert. |
| **CalmPromptService** | Maintains a catalogue of calming prompts and breathing patterns. Returns an appropriate prompt when queried. Rotates prompts to avoid repetition. |
| **SettingsManager** | Reads and writes user preferences (heart rate threshold, prompt style, notification mode) using `Application.Storage`. |
| **BreathingView** | Renders the breathing exercise or mindfulness prompt. Drives simple animations using `WatchUi.View` and timer callbacks. |

### Application Flow

```
Device start
    └── InnerPeaceApp.onStart()
            ├── SettingsManager loads persisted prefs
            ├── HeartRateMonitor starts sensor subscription
            └── Initial InnerPeaceView shown (idle screen)

Heart rate reading arrives (HeartRateMonitor)
    └── ThresholdDetector.evaluate(heartRate)
            ├── [below threshold] → no action
            └── [above threshold + user inactive]
                    ├── CalmPromptService.nextPrompt() → prompt
                    └── WatchUi.pushView(BreathingView(prompt))

User exits BreathingView
    └── WatchUi.popView() → return to idle screen
```

## Design Principles

- **Modular** — each component is independently testable and replaceable.
- **Event-driven** — prefer sensor callbacks over polling to conserve battery.
- **Memory-conscious** — avoid unnecessary object allocations; reuse instances where safe.
- **UI/logic separation** — views contain no business logic; business logic contains no drawing code.

## Notes

This architecture is a proposal. Components and boundaries may evolve as the project grows. Significant changes should be reflected here before implementation begins.
