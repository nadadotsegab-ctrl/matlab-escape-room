# matlab-escape-room
A multi-stage interactive escape room and maze game built in MATLAB, featuring Arduino joystick and LED integration.
# MATLAB Escape Room

A multi-stage, interactive escape room and maze game built entirely in MATLAB. This project features keyboard controls, custom sprite graphics, math puzzles, enemy pathfinding, and hardware integration using an Arduino Uno for physical joystick movement and LED feedback.

## 🎮 The Games

The experience is orchestrated by `Main_Room.m`, which runs the player through a sequence of distinct mini-games:

* **Jonathan's Dungeon (`Example_KeyboardInput_Dungeon.m`):** A dungeon crawler where the player must solve randomized math equations to break down barriers and reach the exit.
* **Ian's Maze Room (`Ian_Maze_Room.m`):** Navigate an endless-feeling maze, avoid the pebble traps, and find the secret door to escape.
* **Rodney's Engineering Project (`Engineering_Proj.m`):** Find the correct pathway without drowning or taking the wrong door. Features Arduino LED feedback based on your in-game status!
* **Hide and Seek (`hide_and_seek_game.m`):** A dynamic stealth game. Collect the key, answer puzzle questions for power-ups (like invincibility and speed boosts), and avoid or sneak-attack patrolling enemies. Playable with a keyboard or a physical Arduino joystick.

## 🛠️ Requirements & Dependencies

To play this game, you will need:
* MATLAB
* MATLAB Support Package for Arduino Hardware (if using the hardware features)
* **Crucial Visual Assets:** `escapeRoomEngine.m` and `terrain_pack.png` must be in the same folder as the scripts to render the graphics properly.

## 🔌 Arduino Hardware Setup

The game features optional hardware integration. If an Arduino Uno is not detected, the game will default to standard keyboard controls (Arrow Keys / WASD). 

If you are setting up the hardware, wire your Arduino as follows:

**LED Indicators (for Rodney's Room):**
* **Green LED (Pin D12):** Lights up when you win / find the correct door.
* **Red LED (Pin D13):** Lights up when you drown or pick the wrong pathway.

**Joystick Controls (for Hide and Seek):**
* **X-axis (VRx):** Analog Pin `A0`
* **Y-axis (VRy):** Analog Pin `A1`
* **Joystick Button (SW):** Digital Pin `D2` (Used for attacking enemies)

## 🚀 How to Play

1. Clone or download this repository.
2. Ensure `terrain_pack.png` and `escapeRoomEngine.m` are in the folder.
3. Open MATLAB and navigate to the folder containing the files.
4. Run `Main_Room.m` in the command window or hit the Run button to start the sequence!

## Author
* Tsegab 
