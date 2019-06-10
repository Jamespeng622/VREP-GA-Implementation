"2modules_sensor.lua" is the code in Maledyn001's childscript. It read the force values from "Force_sensor1~4" per timestep, and output the result into a file named "test_force_output.txt".

"read_force.py" is a python code that visualizes all the force sensor statistics.

"2modules_sensor_mapping.ttt" is a V-Rep scence, needed to be opened by V-Rep. We placed four force_sensors(green dots) under the robot.

Workflow:
After "2modules_sensor_mapping.ttt" finish its simulation, run "read_force.py" to get the mapping of force.