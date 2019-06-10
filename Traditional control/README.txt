"4mod_traditional.lua" is the code in Maledyn001's childscript. It created 3 patterns for 4 modules snake to climb stairs. 
The pattern are like this: smaller amplitude (sin-wave movement) -> bigger amplitude (sin-wave movement) -> half-moving-half-stand movement.
The control parameters are set by trials-and-errors.
You can either use "sim.getObjectPosition()" or "sim.getSimulationTime()" to activate desired movement.
For futher improvement, you can also try implementing sensors on the robot to sense the environment.