# Architecture

## Project Goals

Inner Peace is a Garmin Connect IQ watch application that passively monitors the wearer's heart rate. When it detects an elevated heart rate while the wearer appears sedentary, it surfaces a calming message to help reduce stress. It also delivers proactive encouragement at three fixed times each day. The app is a wellness companion; it must never make medical diagnoses or clinical claims.

## Component Architecture

```
InnerPeaceApp            (Application.AppBase)
│
└── AppController         (lifecycle wiring)
    ├── HeartRateMonitor  (sensor layer)
    ├── StressDetector    (detection logic)
    ├── PositiveMessageRepository  (message catalogue)
    ├── MessageScheduler  (scheduled prompts)
    └── PromptPresenter   (UI coordinator)
        ├── PromptView    (message display)
        └── PromptDelegate (input / dismiss)
```

### Component Responsibilities

| Component | Responsibility |
|---|---|
| **InnerPeaceApp** | Entry point. Owns `AppController` lifecycle (`onStart` / `onStop`). |
| **AppController** | Instantiates and wires all components. Routes sensor callbacks to detection logic and detection results to the presenter. |
| **HeartRateMonitor** | Subscribes to `Sensor.registerSensorDataListener`. Delivers non-null heart rate integers to a callback; null readings are silently dropped. |
| **StressDetector** | Accumulates heart rate readings. Fires when HR has been ≥ threshold for a sustained window while `ActivityMonitor` reports inactivity. Enforces a cooldown between successive events. |
| **PositiveMessageRepository** | Holds four message pools (stress, morning, midday, evening). Returns a random entry from the requested pool. |
| **MessageScheduler** | Runs a 60-second repeating timer. Fires a slot callback at 08:00, 12:30, and 16:30. |
| **PromptPresenter** | Pushes `PromptView` onto the view stack via `WatchUi.pushView`. Guards against duplicate overlays with an `_isShowing` flag reset on dismissal. |
| **PromptView** | Draws the message string centred on a black background. Wraps text at word boundaries using `dc.getTextDimensions`. |
| **PromptDelegate** | Handles back-button press: calls the dismiss callback, then pops the view. |

### Application Flow

```
App start
  └── AppController.initialize() — creates all components
  └── AppController.start()
        ├── HeartRateMonitor.start()  — sensor subscription begins
        └── MessageScheduler.start() — 60-second timer begins

Heart rate reading arrives (HeartRateMonitor)
  └── AppController.onHeartRate(bpm)
        └── StressDetector.evaluate(bpm)
              ├── [below threshold or active] → no action
              └── [≥ threshold, sustained, sedentary, cooldown elapsed]
                    └── AppController.onStressDetected()
                          └── PromptPresenter.show(stressMessage)
                                └── WatchUi.pushView(PromptView, PromptDelegate)

Scheduled time tick (MessageScheduler)
  └── AppController.onScheduledTime(slot)
        └── PromptPresenter.show(scheduledMessage)

User presses back on PromptView
  └── PromptDelegate.onBack()
        ├── PromptPresenter.onDismissed() — clears _isShowing
        └── WatchUi.popView()
```

## Detection Heuristic

The initial stress heuristic uses three conditions (all must be true):

1. **Elevated HR** — current reading ≥ 100 bpm
2. **Sustained** — HR has been ≥ threshold continuously for 60 seconds (`System.getTimer()` delta)
3. **Sedentary** — `ActivityMonitor.getInfo().moveBarLevel > 0` (user has not moved recently)

A 5-minute cooldown prevents repeated alerts. All three thresholds are named constants in `StressDetector` and are easy to adjust or make user-configurable in a future release.

## Design Principles

- **Modular** — each component is independently replaceable.
- **Event-driven** — `Sensor.registerSensorDataListener` delivers callbacks; no polling.
- **Memory-conscious** — components are long-lived singletons; no unnecessary allocations per heartbeat.
- **UI/logic separation** — views contain no business logic; logic contains no drawing code.

## Deferred Components

- **SettingsManager** — user-configurable thresholds via `Application.Storage` (future release)
- **Guided breathing animations** — `BreathingView` with timer-driven animation (future release)
- **Haptic feedback** — vibration on stress detection (future release)
