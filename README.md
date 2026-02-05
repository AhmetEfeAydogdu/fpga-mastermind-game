# Electronic Mastermind Machine on FPGA

## 📌 Project Overview
   This project is a digital implementation of the classic code-breaking game **Mastermind**, designed using **Verilog HDL** and deployed on a **Tang Nano 9K FPGA** board.
   The system features a complex **Finite State Machine (FSM)** to manage game logic, player turns, score tracking, and input/output processing.

The project demonstrates proficiency in digital system design, hardware-software integration, and low-level logic implementation.

## 🎮 Game Modes & Features
* [cite_start]**2-Player Mode:** A turn-based system where one player sets the secret code (Code-Maker) and the other attempts to guess it (Code-Breaker)[cite: 74].
* [cite_start]**Single Player Mode (Bonus):** Integrated a **Linear Feedback Shift Register (LFSR)** based Random Number Generator (RNG) where the user plays against the circuit[cite: 140, 142].
* [cite_start]**Real-time Feedback:** LED indicators provide immediate feedback on the accuracy of guesses (correct color/correct position)[cite: 130, 131].
* [cite_start]**Score & Status Display:** 7-Segment Displays (SSD) show the current score, remaining lives, and active player[cite: 79, 106].
* [cite_start]**Debounced Inputs:** Implemented custom debouncing modules to ensure stable button inputs[cite: 221].

## 🛠️ Tech Stack & Hardware
* [cite_start]**Language:** Verilog HDL [cite: 211]
* [cite_start]**Hardware:** Sipeed Tang Nano 9K FPGA 
* [cite_start]**EDA Tools:** Gowin EDA / Icarus Verilog (for simulation) [cite: 196]
* **Components:**
    * [cite_start]Clock Divider (50Hz generation) [cite: 185, 220]
    * [cite_start]SSD Driver (Multiplexing display) [cite: 222]
    * [cite_start]Button Debouncer [cite: 221]
    * [cite_start]RNG Module (Random Code Generation) [cite: 143]

## 🎲 How It Works (Game Logic)
The game operates on a maximum of **3 rounds**. Players swap roles (Maker/Breaker) after each round. [cite_start]The Code-Breaker has **3 lives** to guess the 4-symbol sequence[cite: 76, 88].

### The FSM (Finite State Machine)
The core logic is controlled by an FSM with the following key states:
1.  **Start State:** Waits for game initiation.
2.  [cite_start]**Code-Maker Input:** Player A enters a 4-letter sequence (A, B, C, D, E, F) hidden from the opponent[cite: 79, 81].
3.  **Code-Breaker Guess:** Player B enters a guess sequence.
4.  **Check Logic:** The system compares the guess against the secret code:
    * **LEDs:** Used to indicate match status. [cite_start]`11` for correct letter & place, `01` for correct letter but wrong place[cite: 131, 132].
5.  [cite_start]**Score Update:** Updates the score on SSD if the guess is correct or lives run out[cite: 86, 89].

## 🔌 Pin Mapping & Controls
| Component | Function | Description |
| :--- | :--- | :--- |
| **Switches (SW0-SW2)** | Input | [cite_start]Select letters (Binary mapped to A-F) [cite: 100, 81] |
| **BTN 3** | Enter | [cite_start]Confirm selection for Player A [cite: 97] |
| **BTN 0** | Enter | [cite_start]Confirm selection for Player B [cite: 98] |
| **BTN 2** | Reset | [cite_start]Hard reset the game/FSM [cite: 99] |
| **SSDs** | Output | [cite_start]Displays Scores, Lives (L-3), and Turn info [cite: 101] |
| **LEDs** | Output | [cite_start]Visual feedback for guess accuracy [cite: 120] |

## 🚀 How to Run
1.  Synthesize the Verilog files using Gowin EDA.
2.  Map the pin constraints (`.cst`) file according to the Tang Nano 9K board specifications.
3.  Upload the bitstream (`.fs`) to the FPGA.
4.  [cite_start]Use **SW3** to toggle between 2-Player and Single-Player modes[cite: 141].

## 📂 Repository Structure
* `/src`: Verilog source codes (`top.v`, `mastermind.v`, `ssd.v`, `debouncer.v`)
* `/sim`: Testbenches and simulation waveforms
* `/docs`: State diagrams (ASM Charts) and project requirements

---
*This project was developed as part of the CS 303 Digital System Design course at Sabanci University.*
