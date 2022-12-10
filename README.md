# Hydraulic-power-plant-Critical-System
This project is a project for learning about Spark Ada, more specifically about programs with Standards Input and Standards Outputs. See pdf for more explanation with images and links.

Running the hydroelectric power plant system-> it initialises the system then runs for ever in a loop which:

1) Reads the status of the water filter, and the current water level and shows the current energy output in 12h at % of aperture of the valve.

2) When previous conditions are met: the water filter is not obstructed(the process of unclogging starts if it was obstructed) and there is enough water level (always a minimum of 15%). The system asks the user to input desired energy output which calculates the % of the aperture of the valve, but if the water level after that is below 15% it will not let that action occur.

3) Prints out the status the loop_invariant expresses that the system stays safe all the time.
