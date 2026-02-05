# Electronic Mastermind Machine on FPGA

## 📌 Project Overview
   This project is a digital implementation of the classic code-breaking game **Mastermind**, designed using **Verilog HDL** and deployed on a **Tang Nano 9K FPGA** board.
   The system features a complex **Finite State Machine (FSM)** to manage game logic, player turns, score tracking, and input/output processing.

The project demonstrates proficiency in digital system design, hardware-software integration, and low-level logic implementation.

## 🎮 Game Modes & Features
* **2-Player Mode:** A turn-based system where one player sets the secret code (Code-Maker) and the other attempts to guess it (Code-Breaker).
* **Single Player Mode (Bonus):** Integrated a **Linear Feedback Shift Register (LFSR)** based Random Number Generator (RNG) where the user plays against the circuit.
* **Real-time Feedback:** LED indicators provide immediate feedback on the accuracy of guesses (correct color/correct position).
* **Score & Status Display:** 7-Segment Displays (SSD) show the current score, remaining lives, and active player.
* **Debounced Inputs:** Implemented custom debouncing modules to ensure stable button inputs.

## 🛠️ Tech Stack & Hardware
* **Language:** Verilog HDL 
* **Hardware:** Sipeed Tang Nano 9K FPGA 
* **EDA Tools:** Gowin EDA / Icarus Verilog (for simulation)
* **Components:**
    * Clock Divider (50Hz generation)
    * SSD Driver (Multiplexing display)
    * Button Debouncer
    * RNG Module (Random Code Generation)

## 🎲 How It Works (Game Logic)
The game operates on a maximum of **3 rounds**. Players swap roles (Maker/Breaker) after each round. The Code-Breaker has **3 lives** to guess the 4-symbol sequence.

### The FSM (Finite State Machine)
The core logic is controlled by an FSM with the following key states:
1.  **Start State:** Waits for game initiation.
2.  **Code-Maker Input:** Player A enters a 4-letter sequence (A, B, C, D, E, F) hidden from the opponent.
3.  **Code-Breaker Guess:** Player B enters a guess sequence.
4.  **Check Logic:** The system compares the guess against the secret code:
    * **LEDs:** Used to indicate match status. `11` for correct letter & place, `01` for correct letter but wrong place.
5.  **Score Update:** Updates the score on SSD if the guess is correct or lives run out.

## 🔌 Pin Mapping & Controls
| Component | Function | Description |
| :--- | :--- | :--- |
| **Switches (SW0-SW2)** | Input | Select letters (Binary mapped to A-F) |
| **BTN 3** | Enter | Confirm selection for Player A |
| **BTN 0** | Enter | Confirm selection for Player B |
| **BTN 2** | Reset | Hard reset the game/FSM |
| **SSDs** | Output | Displays Scores, Lives (L-3), and Turn info |
| **LEDs** | Output | Visual feedback for guess accuracy |

## 🚀 How to Run
1.  Synthesize the Verilog files using Gowin EDA.
2.  Map the pin constraints (`.cst`) file according to the Tang Nano 9K board specifications.
3.  Upload the bitstream (`.fs`) to the FPGA.
4.  Use **SW3** to toggle between 2-Player and Single-Player modes.

## 📂 Repository Structure
* `/src`: Verilog source codes (`top.v`, `mastermind.v`, `ssd.v`, `debouncer.v`)
* `/sim`: Testbenches and simulation waveforms
* `/docs`: State diagrams (ASM Charts) and project requirements

---
*This project was developed as part of the CS 303 Digital System Design course at Sabanci University.*
