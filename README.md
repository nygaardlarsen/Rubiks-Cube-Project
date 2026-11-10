# Rubik's Cube Solver

An interactive 3D Rubik's Cube simulator and solver built using **Processing (Java)**.

The project combines 3D visualization, cube manipulation and algorithms for automatically solving a scrambled Rubik's Cube.

## Features

- Interactive 3D visualization of a 3×3×3 Rubik's Cube
- Manual cube rotations using keyboard controls
- Automatic scrambling and solving
- Two solving implementations: Basic and Optimized
- Adjustable animation speed
- Single, Continuous and Benchmark modes
- Tracking of moves and benchmarking solver performance

## Technologies

- Processing (Java)
- PeasyCam for 3D camera controls

## How to run

1. Install [Processing](https://processing.org/download).
2. Install the **PeasyCam** library through Processing's library manager.
3. Clone this repository.
4. Open `Rubikscube.pde` in Processing.
5. Run the sketch.

## Controls

| Key | Action |
|---|---|
| `X` | Scramble the cube |
| `Z` | Start/stop automatic solving |
| `R` | Reset the cube |
| `S` | Switch between Basic and Optimized solvers |
| `M` | Switch between Single, Continuous and Benchmark modes |
| `+` / `-` | Adjust animation speed |
| `1–9`, `Q–P` | Perform manual cube rotations |

## Project structure

| File | Description |
|---|---|
| `Rubikscube.pde` | Main application, rendering and program state |
| `Algorithms.pde` | Cube-solving algorithms |
| `Cube.pde` | Representation of individual cube pieces |
| `Face.pde` | Cube face representation |
| `Move.pde` | Representation of cube moves |
| `Turns.pde` | Cube rotation logic |
| `Scramble.pde` | Scrambling functionality |
| `Controls.pde` | Keyboard controls |
| `helperFunction.pde` | Supporting functions |

## About the project

This project was an opportunity to explore algorithmic problem-solving through a visual and interactive application.

One of the main challenges was representing the cube's state and implementing rotations correctly while keeping the visualization synchronized with the solving algorithms.

The project also includes functionality for comparing different solving implementations through benchmarking.