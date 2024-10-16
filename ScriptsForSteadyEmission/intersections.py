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


def find_intersection_x_values(mu_line_range, probabilities,target_y):
    # Interpolating the function for finding intersections
    interpolated_func = interp1d(mu_line_range, probabilities, kind='cubic')

    # Finding the intersection with target_y
    try:
        x_intersection = brentq(lambda x: interpolated_func(x) - target_y, mu_line_range[0], mu_line_range[-1])
        return x_intersection
    except ValueError:
        # In case of no intersection within the range, return None
        return None