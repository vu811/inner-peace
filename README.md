# Inner Peace

A Garmin Connect IQ watch application that monitors your heart rate and, when elevated heart rate is detected while you appear inactive, displays calming guidance such as breathing exercises or mindfulness prompts.

**This application is a wellness companion and does not make medical diagnoses or claims.**

## Features (Planned)

- Passive heart rate monitoring during rest periods
- Elevated heart rate detection with inactivity context
- Guided breathing exercises
- Mindfulness prompts and reminders
- Configurable heart rate thresholds
- Haptic feedback on alerts

## Prerequisites

- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) (4.x or later)
- [Visual Studio Code](https://code.visualstudio.com/) with the [Monkey C extension](https://marketplace.visualstudio.com/items?itemName=garmin.monkey-c)
- A supported Garmin device or the Garmin Connect IQ simulator

## Build

### Using VS Code

1. Open the project folder in VS Code.
2. Press `Ctrl+Shift+P` and run **Monkey C: Build Current Project**.
3. Select a target device when prompted.
4. The compiled `.prg` file is written to `bin/`.

### Using the SDK CLI

```bash
monkeyc \
  -o bin/inner-peace.prg \
  -f monkey.jungle \
  -d <device-id> \
  -y developer_key.der
```

Replace `<device-id>` with a value from the [supported devices list](https://developer.garmin.com/connect-iq/compatible-devices/), e.g. `fenix7`.

## Running in the Simulator

1. Build the project (see above).
2. Launch the Garmin Connect IQ Simulator: open VS Code, press `Ctrl+Shift+P`, and run **Monkey C: Run Current Project in Simulator**.
3. The simulator opens with the compiled app loaded on the chosen device.

Alternatively, from the SDK CLI:

```bash
# Start the simulator
connectiq

# In a second terminal, deploy the app to the running simulator
monkeydo bin/inner-peace.prg <device-id>
```

## Deployment to a Personal Device

1. Connect your Garmin device via USB.
2. Build the project for your specific device model.
3. Copy the compiled `.prg` file to `GARMIN/APPS/` on the device storage.
4. Safely eject the device; the app appears in the app drawer after the device restarts.

> A developer key (`developer_key.der`) is required for side-loading. Generate one with `openssl` following the [Garmin developer guide](https://developer.garmin.com/connect-iq/connect-iq-basics/getting-started/).
