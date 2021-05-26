import sys; sys.path.insert(1, '/path/to/wind-dynamics/python') # if your script is not in the wind-dynamics/python directory

from wind_dynamics import DrydenWind
import numpy as np

...

wind = DrydenWind()
wind.initialize(x_mean,  y_mean,  z_mean, 
                x_sigma, y_sigma, z_sigma, 2.0)

...

v_wind = wind.getWind(dt)
