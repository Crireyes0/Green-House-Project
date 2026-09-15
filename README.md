# 🌱 Smart Greenhouse Project

> **Automated Environmental Monitoring & Control System**  
> MCET-101 Fundamentals of Engineering

**Project Lead:** Cristian Reyes  
**Team:** James, Caden Lynch, Roy, Kristoff  
**Instructor:** Veneziano  
**Date:** November 14, 2025

---

## Overview

The Smart Greenhouse Project is a semi-automatic environmental monitoring and control system designed to enable the cultivation of plants and food with minimal manual intervention. I led the design and integration of a multi-sensor Arduino platform paired with a MATLAB data acquisition pipeline that continuously logs and displays real-time environmental data for review and adjustment.

The system monitors four key parameters simultaneously:

| Sensor | Unit | Function |
|--------|------|----------|
| **Photosensor** | Lux | Measures ambient light levels to assess daily sun exposure |
| **Water Level Sensor** | Millimeters (mm) | Works with an automatic drip system to water plants without overwatering |
| **Humidity Sensor** | °C / %RH | Activates a ventilation fan when humidity exceeds the target range |
| **Motion Sensor** | Binary | Detects unexpected movement within the greenhouse enclosure |

---

## Repository Structure

```
SmartGreenhouse/
├── Cristian_Reyes_Arduino_Ide.ino   # Arduino firmware — sensor polling & serial CSV output
├── openSerial.m                     # MATLAB helper — opens & configures the serial port
├── readSerialPacket.m               # MATLAB helper — reads & parses one CSV data packet
├── Cristian_Reyes_SerialTest.mlx    # MATLAB Live Script — serial link diagnostic tool
└── Greenhouse.mlx                   # MATLAB Live Script — main data acquisition & visualization
```

---

## Hardware Requirements

- Arduino Uno (or compatible board)
- Photosensor / LDR module
- Water level sensor
- DHT11 or DHT22 humidity/temperature sensor
- PIR motion sensor
- Small DC fan (humidity control actuator)
- USB cable + laptop

---

## Software Requirements

- [Arduino IDE](https://www.arduino.cc/en/software) (any recent version)
- MATLAB R2021a or later with the **Instrument Control Toolbox**

---

## Getting Started

### 1. Upload the Firmware

Open `Cristian_Reyes_Arduino_Ide.ino` in the Arduino IDE, select your board and port, and click **Upload**. The sketch polls all sensors and transmits calibrated readings over serial at **115200 baud** using a comma-separated value (CSV) format with CR/LF line termination.

### 2. Identify Your COM Port

In the Arduino IDE, go to **Tools → Port** and note the port name assigned to your device (e.g., `COM3` on Windows, `/dev/ttyUSB0` on Linux/Mac).

### 3. Run the Diagnostic Script (Optional but Recommended)

In MATLAB, open and run `Cristian_Reyes_SerialTest.mlx` to confirm the serial link is working and packets are being parsed correctly before launching the full system.

### 4. Launch the Main Acquisition Script

Open and run `Greenhouse.mlx` in MATLAB. The script will call `openSerial()` to establish the connection and begin reading sensor packets via `readSerialPacket()`, displaying all logged data in real time.

```matlab
% Quick start example
sp = openSerial("COM3");          % Open serial port (default: 115200 baud, CR/LF, 5s timeout)
data = readSerialPacket(sp);      % Read one CSV packet → returns numeric row vector
```

---

## MATLAB Helper Functions

### `openSerial.m`
Opens and configures a `serialport` object for line-based CSV packets.

```matlab
sp = openSerial("COM3")                  % 115200 baud, CR/LF terminator, 5s timeout (defaults)
sp = openSerial("/dev/ttyUSB0", 230400)  % Custom baud rate
sp = openSerial("COM4", [], "LF")        % LF-only terminator
```

### `readSerialPacket.m`
Reads a single terminated line from the serial port, splits on commas, and returns a validated numeric row vector. Handles trailing commas, extra whitespace, and empty lines gracefully.

```matlab
data = readSerialPacket(sp);   % Returns e.g. [842.0, 23.5, 78.0, 0.0]
%                                              [lux,   °C,   %RH,  motion]
```

---

## How It Works

Each team member was assigned a dedicated sensor subsystem — responsible for understanding its operating principles, calibrating it to engineering units, writing Arduino code, and integrating the hardware into a shared circuit. I coordinated the team and established the standardized serial CSV protocol that ties all subsystems together into a single data stream.

```
[Sensors] → [Arduino] --serial CSV--> [MATLAB openSerial/readSerialPacket] --> [Greenhouse.mlx display]
```

The system operates semi-automatically: once the firmware is uploaded and the MATLAB script is running, no further manual intervention is required unless the water reservoir needs refilling.

---

## Results

- All four sensors were successfully calibrated and verified to output correct measurements in engineering units.
- End-to-end system integration was tested prior to demo day, with full functionality confirmed and recorded on video.
- On demo day, each team member demonstrated their subsystem and explained its operating principle without requiring manual operation beyond starting the program.

---

## Team Contributions

| Member | Role |
|--------|------|
| **Cristian Reyes** | Project Lead — system architecture, serial protocol, MATLAB pipeline, overall integration |
| James | Sensor research, calibration, firmware, circuit integration |
| Caden Lynch | Sensor research, calibration, firmware, circuit integration |
| Roy | Sensor research, calibration, firmware, circuit integration |
| Kristoff | Sensor research, calibration, firmware, circuit integration |

---

## License

This project was developed for academic purposes as part of MCET-101 Fundamentals of Engineering.
