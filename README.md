# Automated Greenhouse Monitoring & Control System

Embedded sensing and control system for greenhouse environmental management, built on Arduino and MATLAB. The system acquires light, water level, motion, temperature, and humidity data, and drives automated responses (alert indicators, fan control) based on configurable thresholds.

**Platform:** Arduino (Uno-compatible) · MATLAB (Arduino Hardware Support Package)

---

## Overview

The system is organized into two independent subsystems that together form a complete environmental monitoring and control pipeline:

| Subsystem | Sensors | Communication Method | Outputs |
|---|---|---|---|
| Light / Water / Motion | Photoresistor, water level sensor, PIR motion detector | Direct hardware I/O (MATLAB Arduino Support Package) | Dual-tier LED alerting |
| Climate | DHT11 (temperature & humidity) | Serial (custom CSV protocol, 115200 baud) | Automated fan control |

Each subsystem can operate independently; combined, they provide full-cycle greenhouse monitoring: ambient light, irrigation level, perimeter security, and climate regulation.

## System Architecture

```
                    ┌─────────────────────────┐
                    │        Arduino           │
                    │                           │
  Photoresistor ───▶│  A0/A5   Analog In        │
  Water Level    ──▶│  A0/A5   Analog In        │──▶ MATLAB (direct hardware I/O)
  PIR Motion     ──▶│  D5      Digital In        │        via arduino() object
  Minor/Major LED◀──│  D2/D3   Digital Out       │
                    │                           │
  DHT11          ──▶│  D2      Digital In        │
  Fan Relay      ◀──│  D4      Digital Out       │──▶ Serial (CSV @ 115200 baud) ──▶ MATLAB
                    └─────────────────────────┘        via openSerial / readSerialPacket
```

## Repository Structure

```
├── Greenhouse.mlx                    # Main monitoring loop: light, water level, motion, LED alerts
├── Cristian_Reyes_Arduino_Ide.ino    # Arduino firmware: DHT11 acquisition + fan control + serial TX
├── openSerial.m                      # Serial port initialization
├── readSerialPacket.m                # CSV serial packet parser
└── Cristian_Reyes_SerialTest.mlx     # Serial acquisition test / logging script
```

## Hardware

| Component | Function |
|---|---|
| Arduino Uno (or compatible) | Microcontroller |
| Photoresistor (LDR) + fixed resistor | Ambient light sensing |
| Analog water level sensor | Irrigation / reservoir level sensing |
| PIR motion sensor | Perimeter / intrusion detection |
| DHT11 | Temperature & humidity sensing |
| 2× LED | Minor / major motion alert indicators |
| Fan + driver circuit | Climate control actuation |

### Pin Configuration

| Signal | Pin | Direction |
|---|---|---|
| Photoresistor | A5 | Analog In |
| Water Level Sensor | A0 | Analog In |
| Motion Detector | D5 | Digital In |
| Minor Alert LED | D3 | Digital Out |
| Major Alert LED | D2 | Digital Out |
| DHT11 | D2 | Digital In |
| Fan Control | D4 | Digital Out |

## Software Design

### Light / Water / Motion Monitoring — `Greenhouse.mlx`

Connects directly to the Arduino using MATLAB's Arduino Hardware Support Package (`arduino()`), eliminating the need for a custom serial protocol. Runs a fixed-duration sampling loop (default: 120 samples, 1 s interval) and performs:

- **Lux calculation** — photoresistor voltage converted to LDR resistance, then to Lux via a calibrated power-law model:

  ```
  R_LDR = R_fixed × (Vcc / V_measured − 1)
  Lux   = (A / R_LDR) ^ (1 / B)
  ```

- **Water level conversion** — analog voltage scaled to millimeters via an empirical conversion factor.
- **Motion event handling** — logs each trip; escalates to a "Major Motion Detected" alert if trip count exceeds a configurable sensitivity threshold within a configurable time window.
- **Session summary** — reports average Lux, average water level, total trips, and total major-motion events at completion.

### Climate Monitoring & Fan Control — Serial Pipeline

The Arduino firmware operates independently of MATLAB:

1. Samples the DHT11 every 5 seconds.
2. Evaluates fan control logic locally (on-board), using raw sensor values — fan engages if humidity exceeds 30% or temperature exceeds the configured limit.
3. Transmits a CSV-formatted packet (`humidity,temperature,value,id`) over serial at 115200 baud; invalid readings are sent as sentinel values (`-1`) rather than dropped, so MATLAB always receives a well-formed line.

On the MATLAB side:

- `openSerial.m` — opens and configures the serial port (baud rate, line terminator, timeout).
- `readSerialPacket.m` — parses each incoming line into a numeric row vector, with input validation for malformed packets.
- `Cristian_Reyes_SerialTest.mlx` — reference implementation demonstrating a full acquisition loop (100 samples).

## Getting Started

### Prerequisites

- MATLAB with the **Arduino Hardware Support Package** installed
- Arduino IDE with the **Adafruit DHT sensor library**

### Light / Water / Motion Monitoring

1. Wire sensors and LEDs per the pin configuration table above.
2. Update the serial port in `Greenhouse.mlx` (e.g., `'COM3'`) to match your system.
3. Run `Greenhouse.mlx` in MATLAB.

### Climate Monitoring & Fan Control

1. Flash `Cristian_Reyes_Arduino_Ide.ino` to the Arduino via the Arduino IDE.
2. Ensure `openSerial.m` and `readSerialPacket.m` are on the MATLAB path.
3. Update the serial port in `Cristian_Reyes_SerialTest.mlx` and run to begin logging.

## Key Concepts Demonstrated

- Analog and digital sensor interfacing
- Sensor calibration and signal-to-physical-unit conversion
- Closed-loop, threshold-based automated control
- Two hardware communication architectures: direct hardware I/O vs. custom serial protocol
- Real-time data acquisition, parsing, and logging

## Author

Cristian Reyes
