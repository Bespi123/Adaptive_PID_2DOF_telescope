
# URUCON Simulation and Control of a Mount for a Telescope

## Overview

This project focuses on simulating and controlling a 2-DOF (degrees of freedom) telescope mount for astronomical observations and Low Earth Orbit (LEO) satellite tracking. The project utilizes a dynamic model of the telescope, applying adaptive PID control optimized by genetic algorithms to achieve precise positioning for tracking purposes. The code simulates telescope azimuth and elevation movements, plotting data extracted from .frd files to visualize the control system's performance.

The main goals of the project are:
- To simulate the telescope's behavior based on kinematic and dynamic models.
- To control the telescope using an adaptive PID controller optimized by a genetic algorithm.
- To track LEO satellites by adjusting the telescope's azimuth and elevation.

## Files

### Code
- `readFrd.m`: This MATLAB function reads .frd files containing azimuth and elevation data. The function extracts information such as seconds of day (`sod`), azimuth (`az`), and elevation (`el`), and stores them in a structured format.
- `calculateRisingTime.m`: Calculates the rising time of the signal based on the data extracted from the .frd file.
- `calculateSettlementTime.m`: Calculates the settling time of the signal from the .frd file, using a specified tolerance level.
- `calculateOvershoot.m`: Determines the maximum overshoot of the telescope's response.

### Input Data
- `.frd` files: These contain observational data for telescope movements. The files provide azimuth and elevation angles over time, which are used to simulate and control the telescope's pointing accuracy.

### Simulation
- The main script reads the `.frd` files using `readFrd.m` and then plots the azimuth and elevation data using MATLAB's plotting functions.

## How to Use

1. **Download the Project**: Clone or download this repository into your MATLAB working directory.
2. **Set Up Data**: Ensure that the `.frd` files are located in the directory structure specified in the code (`BRAYAN/*/*e?????????.frd`). Modify the path in the script if necessary.
3. **Run the Simulation**: Execute the main MATLAB script to:
    - Read the `.frd` files.
    - Simulate the telescope's azimuth and elevation response.
    - Plot the results to observe the system's performance.
4. **Modify and Customize**: You can modify the genetic algorithm parameters or PID controller gains to optimize the control system based on different simulation needs.

### Example of Plot Output
The code generates plots that show:
- Azimuth and elevation angles over time for each satellite or observation session.
- A figure for each `.frd` file is generated, plotting the azimuth and elevation data.

## Requirements
- MATLAB (R2018 or newer recommended)
- Simulink (for control system simulation)
- `.frd` data files with satellite or observational data.

## Contact
For any questions or contributions, feel free to contact:
- **B. Espinoza-Garcia** at `bespinozag@unsa.edu.pe`
- **P.R. Yanyachi** at `raulpab@unsa.edu.pe`
- **Jaime Gerson Cuba Mamani** at `jcubam@unsa.edu.pe`

This project was developed at the *Instituto de Investigación Astronómico y Aeroespacial Pedro Paulet*, Universidad Nacional de San Agustín de Arequipa.
