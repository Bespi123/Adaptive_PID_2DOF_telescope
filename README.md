
# Simulation and Control of a Mount for a Telescope

## Overview

This project focuses on simulating and controlling a 2-DOF (degrees of freedom) telescope mount for astronomical observations and Low Earth Orbit (LEO) satellite tracking. The project utilizes a dynamic model of the telescope, applying adaptive PID control optimized by genetic algorithms to achieve precise positioning for tracking purposes. The code simulates telescope azimuth and elevation movements, plotting data extracted from .frd files to visualize the control system's performance.

The main goals of the project are:
- To simulate the telescope's behavior based on kinematic and dynamic models.
- To control the telescope using an adaptive PID controller optimized by a genetic algorithm.
- To track LEO satellites by adjusting the telescope's azimuth and elevation.

## Main Files
- The main script to test regulation maneuvers is the `regulationEvaluation`.
- The main script to test regulation maneuvers is the `trackingEvaluation`.
- The optimization algorithm for tunning the control algorithm based on genetic algorithms is coded in  `optimizationProgram`.
  
## How to Use

1. **Download the Project**: Clone or download this repository into your MATLAB working directory.
2. **Set Up Data**: Ensure all the files and subfiles are included in the MATLAB path.
3. **Run the Simulation**: Execute the main MATLAB script to:
    - The main script to test regulation maneuvers is the `regulationEvaluation`.
    - The main script to test regulation maneuvers is the `trackingEvaluation`.
4. **Modify and Customize**: You can modify the genetic algorithm parameters or PID controller gains to optimize the control system based on different simulation needs.

### More information
For additional information refer to `report.pdf`.

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
