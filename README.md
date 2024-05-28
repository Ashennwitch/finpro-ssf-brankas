# Arduino-Based Safe with Password Setup and Verification

## Introduction to the Problem and Solution
In today's digital era, the need for advanced and efficient security systems is urgent. Conventional locks like physical keys and mechanical combinations are often inadequate and easily breached. Additionally, these systems are impractical for daily management and use.

The "Arduino-Based Safe with Password Setup and Verification" project addresses these issues by designing a safe using an Arduino microcontroller and assembly programming. This system allows users to set and verify passwords securely and in a user-friendly manner. Leveraging Arduino technology and the efficiency of assembly programming, this project strives to create a more effective and practical security solution than traditional systems.

## Hardware Design and Implementation
The hardware design includes:
- **Arduino Uno:** Main microcontroller.
- **MAX7219 LED Dot Matrix:** Displays the status of the safe.
- **Potentiometers (3):** User input for setting and entering the password.
- **Buttons (2):** Triggers for saving the password and operating the servo.
- **LEDs (4):** Visual indicators.
- **LDR Photoresistor:** Light sensor to control LEDs.
- **Servo:** Acts as the safe's locking mechanism.
- **Transistor and Buzzer:** Alarm system.

### Schematic and Connections
The schematic, created using Proteus, illustrates the connections among components. Arduino Uno is the central microcontroller, connected to MAX7219 LED Dot Matrix, potentiometers, buttons, LEDs, LDR photoresistor, servo, and buzzer. **Check file .pdsprj on the master**

## Software Implementation
Software development uses Assembly for Arduino operations and C for the main program. The workflow involves:
1. **System Initialization:** Initializes components and registers, activates serial communication, ADC, and interrupts.
2. **Password Input:** Users adjust potentiometers to enter the password, which is converted to digital values and stored in registers.
3. **Password Storage:** The entered password is saved as the valid password when the save button inside the safe is pressed.
4. **Password Comparison:** Compares the entered password with the stored valid password, triggering actions based on the match.
5. **Servo Control:** Rotates the servo to unlock (90 degrees) or lock (0 degrees) the safe.
6. **Indicators and Alarm:** LEDs and MAX7219 display the status, and the buzzer sounds after three incorrect password attempts.

### Hardware and Software Integration
Integration involves connecting hardware components according to the schematic and uploading the compiled code to the Arduino Uno using the Arduino IDE. Testing ensures each system part functions as expected, with necessary adjustments made for any issues.

## Test Results and Performance Evaluation
Thorough testing verified that the system meets specifications:
- **Password Input and Storage:** Potentiometers accurately input and store passwords.
- **Status Display:** MAX7219 LED Dot Matrix displays "L" (Locked), "U" (Unlocked), and "A" (Alarm) correctly.
- **Servo Operation:** Servo correctly locks and unlocks the safe based on password validation.
- **Alarm System:** Buzzer activates after three incorrect password attempts.
- **Light Detection:** LDR controls internal LED lighting effectively.

## Conclusion and Future Work
The project successfully designed and implemented an Arduino-based safe with secure password management. While functional, improvements can be made in potentiometer consistency and adding features like activity logging or wireless connectivity. This project demonstrates the potential of microcontrollers and assembly programming in developing advanced and practical security systems.

---
