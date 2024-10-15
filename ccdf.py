import os
from astropy.io import fits
import sys
import glob
import numpy as np
from scipy.integrate import quad
from scipy.optimize import brentq
from scipy.interpolate import interp1d
from pmf import global_calculation
import matplotlib.pyplot as plt 
from scipy.integrate import simps


import numpy as np
from scipy.integrate import simps

def calculation_of_ccdf(list_x, list_ccdf, list_exp):
    """
    Calculates the scaled cumulative complementary distribution functions (CCDFs) 
    based on input x-values, CCDF values, and exposure values.

    Parameters:
    - list_x: List of numpy arrays containing x-values.
    - list_ccdf: List of numpy arrays containing CCDF values.
    - list_exp: List of exposure values corresponding to each CCDF.

    Returns:
    - scaled_ccdf: List of scaled CCDF values.
    - scaled_x: List of scaled x-values corresponding to the CCDFs.
    """
    scaled_ccdf = []
    scaled_x = []

    for x_values, ccdf_values, exposure in zip(list_x, list_ccdf, list_exp):
        # Ensure x and CCDF are numpy arrays and not empty
        if isinstance(x_values, np.ndarray) and isinstance(ccdf_values, np.ndarray) and x_values.size > 0 and ccdf_values.size > 0:
            # Handle case where both x and CCDF are zero
            if np.all(x_values == 0) and np.all(ccdf_values == 0):
                scaled_ccdf_values = np.zeros_like(ccdf_values)  # Return zeros of the same size as ccdf
            else:
                # Scale x-values by exposure
                scaled_x_values = x_values / exposure if exposure != 0 else np.zeros_like(x_values)
                
                # Normalize the CCDF
                area = simps(ccdf_values, scaled_x_values)  # Calculate the area under the curve
                scaling_factor = 1 / area if area != 0 else 0  

                # Scale the CCDF curve
                scaled_ccdf_values = ccdf_values * scaling_factor
        else:
            # If exposure is zero or inputs are invalid
            scaled_x_values = 0
            scaled_ccdf_values = 0

        scaled_ccdf.append(scaled_ccdf_values)
        scaled_x.append(scaled_x_values)

    return scaled_ccdf, scaled_x




def calculation_of_ccdf_second(list_x,list_ccdf):

    scaled_ccdf=[]
    scaled_x=[]
    
    for (a, b) in zip(list_x, list_ccdf):
        
        if len(a) > 0 and len(b) > 0:
            a=np.array(a)
            b=np.array(b)
            area = simps(b, a)
            

            scaling_fac = 1 / area if area != 0 else 0

            
            b_scaled = b * scaling_fac

         
        

        scaled_ccdf.append(b_scaled)
        scaled_x.append(a)

    return scaled_ccdf, scaled_x
