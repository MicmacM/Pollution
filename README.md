# Pollution
Resolving the transport equation to visualise the evolution of a pollutant cloud

## About
At the Ecole Centrale de Lyon, we had to elaborate a code to simulate the propagation of a fictional pollutant cloud, and analyze the concentration of pollutant to see if it was noxious.

## How it works
### Modelisation of the problem
3 factories are emitting pollutant, we have access to the wind velocity at $\Delta t$ intervals. The propagation of the pollutant cloud is modelled by the transport equation.

We are modelling the equation using : 

$$ \frac{\partial \overline{C}}{\partial t} + \overline{u}\cdot \nabla \overline{C} = D_t\Delta\overline{C} + S + F$$

where $\overline{C}$ is the averaged concentration of pollutant, $D_t$ is the diffusion coefficient, $S$ is the source term, it represent the 3 factories that emit pollutants, and F represent the deposition (dry or wet) of the pollutant from the cloud in the soil.

The deposition of pollutant is modelled by the equation

$$ F = k\cdot \overline{C}$$

### Numerical approximation

The laplacian is approximated using the 5 point method :

$$\Delta u(x,y) = \frac{4 U_{i,j} - U{i+1, j}- U{i-1, j}- U{i, j+1}- U{i, j-1}}{h^2}$$

where h represent the spatial step.

Likewise, $$\frac{\partial \overline{C}}{\partial t} = \frac{C_{i,j}^{(n+1)} - C_{i,j}^{(n)}}{\Delta t}$$

## Results

Several figures and data on the deposited pollutants were obtained, leading to the conclusion that the factories were noxious.

![alt text](https://github.com/MicmacM/Pollution/raw/main/assets/result_simu.gif)

## Workspace description

The [`main.m`](libs/main.m) program executes the code and shows the results. The core of the simulation is handled in the [`simulation.m`](libs/simulation.m). The others files are mainly utility functions.
