import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import poisson
from scipy.integrate import quad
from scipy.optimize import brentq
from scipy.interpolate import interp1d
from scipy.integrate import simps
import math
from math import modf
from pmf import global_calculation



def find_intersection_x_values(mu_line_range, probabilities, target_y=0.5):
    # Interpolating the function for finding intersections
    interpolated_func = interp1d(mu_line_range, probabilities, kind='cubic')

    # Finding the intersection with target_y
    try:
        x_intersection = brentq(lambda x: interpolated_func(x) - target_y, mu_line_range[0], mu_line_range[-1])
        return x_intersection
    except ValueError:
        # In case of no intersection within the range, return None
        return None



def half_area_function(x, N_total, mu_cont, total_area):
    return integrate_function(lambda mu_line: P_total(N_total, mu_cont, mu_line), 0, x) - total_area / 2


def integrate_function(func, start, end):
    result, _ = quad(func, start, end)
    return result




def plot_P_total(N_total, mu_cont):
    """
    Computes maximum mean line and percentiles from the probability distribution.

    Parameters:
    ----------
    N_total : float
        Total photon count.
    mu_cont : float
        Estimated continuum.

    Returns:
    -------
    tuple:
        max_mu_line (float): The maximum mean line value.
        percentile_2_mu_line (float): The 2.5th percentile mean line value.
        percentile_95_mu_line (float): The 95th percentile mean line value.
    """

    frac_part, int_part = modf(N_total)

    try:
        P_total_values, mu_line_range = global_calculation(N_total, mu_cont)
    except Exception as e:
        print("Error in global_calculation:", e)
        return None, None, None

    # Check for empty arrays
    if P_total_values.size == 0 or mu_line_range.size == 0:
        print("P_total_values or mu_line_range is empty.")
        return None, None, None

    # Area under the probability distribution
    area = np.trapz(P_total_values, mu_line_range)
    cumulative_sum = np.cumsum(P_total_values) * (mu_line_range[1] - mu_line_range[0])
    max_prob_index = np.argmax(P_total_values)
    max_mu_line = mu_line_range[max_prob_index]

    # Percentile calculations
    if max_mu_line == 0:
        percentile_95_index = np.searchsorted(cumulative_sum, 0.95 * area)
        percentile_2_index = None
        percentile_95_mu_line = mu_line_range[percentile_95_index]
        percentile_2_mu_line = None
    else:
        percentile_95_index = np.searchsorted(cumulative_sum, 0.975 * area)
        percentile_2_index = np.searchsorted(cumulative_sum, 0.025 * area)
        percentile_95_mu_line = mu_line_range[percentile_95_index]
        percentile_2_mu_line = mu_line_range[percentile_2_index]

    return max_mu_line, percentile_2_mu_line, percentile_95_mu_line






