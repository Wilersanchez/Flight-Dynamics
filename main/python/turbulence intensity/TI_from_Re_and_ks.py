"""

N.T.Basse 2019

Based on paper:
    Turbulence Intensity Scaling: A Fugue
    https://www.mdpi.com/2311-5521/4/4/180

"""

import numpy as np
from scipy.optimize import fsolve

#smooth friction factor (Eq. 19 in paper)
def smooth(x):
    out = [np.power(x[0],-0.5)-1.930*np.log10(Re*np.sqrt(x[0]))+0.537]
    return out

#rough friction factor (Eq. 20 in paper)
def rough(x):
    out = [np.power(x[0],-0.5)+2*np.log10(k_s_norm/(2*3.7)+2.51/(Re*np.sqrt(x[0])))]          
    return out

#user supplies Reynolds number Re [dimensionless]
Re=1.3e6

#user supplies pipe radius a [m]
a=0.13/2

#user supplies sand-grain roughness k_s [m]
k_s=0.0

#normalized sand-grain roughness is calculated [dimensionless]
k_s_norm=k_s/a

#calculate friction factor
if k_s==0:
    print('Smooth pipe')
    ff = fsolve(smooth, 0.01)
else:
    print('Rough pipe')
    ff = fsolve(rough,0.01)
    
print('friction factor:')    
print(ff)   

#calculate turbulence intensity (Eq. 29 in paper)
TI=0.0276*np.log(ff)+0.1794
    
print('turbulence intensity:')
print(TI)

