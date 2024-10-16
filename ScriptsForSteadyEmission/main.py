import os
from astropy.io import fits
import sys
import glob
import numpy as np
from scipy.integrate import quad
from scipy.optimize import brentq
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt 
from scipy.integrate import simps
from itertools import compress

####EXTERNAL SCRIPTS
from pmf import global_calculation
from data import extract_data_for_year_and_index
from data import extract_data_flux
from data import obtain_poisson_cruve
from plots import plot_result

from ccdf import calculation_of_ccdf
from ccdf import calculation_of_ccdf_second
from intersections import find_intersection_x_values



import concurrent.futures
import logging


logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')




plt.rcParams['text.usetex'] = True
# Adjust font sizes using rcParams
plt.rcParams['font.size'] = 12         # Default font size for all text (unless overridden below)
plt.rcParams['axes.labelsize'] = 14    # Font size for x and y labels
plt.rcParams['xtick.labelsize'] = 12   # Font size for x-axis tick labels
plt.rcParams['ytick.labelsize'] = 12   # Font size for y-axis tick labels
plt.rcParams['axes.titlesize'] = 12   # Font size for plot title
plt.rcParams['legend.fontsize'] = 12   # Font size for legend

plt.rcParams['font.weight'] = 'bold'        # Set global font weight to bold
plt.rcParams['axes.labelweight'] = 'bold'   # Font weight for x and y labels
plt.rcParams['axes.titleweight'] = 'bold'   # 



def extract_data_and_compute_global_calculations(years, index):
    """
    Extracts data for the given years and pixel index, computes the Bayesian posterior density for the 6.4 keV line, 
    and normalizes the posterior density.

    Parameters:
    ----------
    years : list of int
        List of years for which data is to be extracted.
    index : int or tuple
        Pixel index used for data extraction. The extraction is executed pixel by pixel in the image. 
        For example, the Sgr B image has 900 pixels arranged in a (30, 30) grid. The index can either be a flattened 
        index (0 to 899) or a tuple (i, j) from the 2D array.

    Returns:
    -------
    tuple
        A tuple containing:
        - results : list of tuples
            Each tuple contains:
                - normalized posterior density (array)
                - mu_line (array)
                - exposure value (float)
        - processed_years : list of int
            List of years for which data was successfully processed.
    """
    results = []
    processed_years = []  # To track successfully processed years

    for year in years:
        # Extract data for the specific year and pixel index
        ntot, mucont, exp_value = extract_data_for_year_and_index(year, index)
        
        # Skip processing any invalid pixels/years 
        if ntot < 0 or mucont < 0:
            continue
        
        # Perform global calculation and normalize posterior density if exposure is non-zero
        if exp_value != 0:
            posterior_density, x_values = global_calculation(ntot, mucont)
            normalized_density = posterior_density / simps(posterior_density, x_values)
            results.append((normalized_density, x_values, exp_value))
        else:
            # Append zeros if exposure value is zero
            results.append((0, 0, exp_value))

        # Add the successfully processed year to the list
        processed_years.append(year)

    return results, processed_years



def compute_ccdfs(data):
    """
    Computes the Complementary Cumulative Distribution Functions (CCDF) for the given data.

    Parameters:
    ----------
    data : list of tuples
        List of tuples where each tuple contains:
        - pdf (array-like): Probability density function of the line.
        - mu_line (array-like): Corresponding x-values (mu_line).
        - exp_value (float): Exposure value for the pixel.

    Returns:
    -------
    list
        A list of CCDFs for each data entry. If the exposure value is zero, the CCDF will be zero.
    """
    ccdfs = []
    
    for y, x, exp in data:
        # If exp is non-zero, compute CCDF
        if exp != 0:
            # Calculate the differences between consecutive x values (dx)
            dx = np.diff(x)
            
            # Approximate the area of each segment (y * dx)
            segment_areas = y[:-1] * dx
            
            # Compute the CDF by cumulative sum of segment areas
            cdf = np.cumsum(segment_areas)
            cdf = np.insert(cdf, 0, 0)  # Start the CDF with 0
            
            # Clip CDF values to the range [0, 1] to ensure valid probabilities
            cdf_clipped = np.clip(cdf, 0, 1)
            
            # Compute CCDF as 1 - CDF
            ccdf = 1 - cdf_clipped
        else:
            # If exp is zero, CCDF is zero
            ccdf = 0
        
        ccdfs.append(ccdf)
    
    return ccdfs


def scale_and_interpolate(data, ccdfs):
    """
    Scales and interpolates the CCDFs based on the provided data.

    Parameters:
    - data : list of tuples
        List of tuples where each tuple contains:
        - pdf (array-like): Probability density function of the line.
        - mu_line (array-like): Corresponding x-values (mu_line).
        - exp_value (float): Exposure value for the pixel.

    - ccdfs: A list of CCDFs corresponding to the x-values in `data`.

    Returns:
    - x_common: A uniform set of mu_line (array-like) for interpolation.
    - interpolated_y_values: A list of interpolated CCDF values corresponding to `uniform mu_line`.
    
    """

    # Extract x-values, CCDFs, and expected values from the data
    list_x = [item[1] for item in data]
    ccdf_list = ccdfs
    exp_list = [item[2] for item in data]

    # Perform CCDF calculation (assuming this function is defined elsewhere)
    scaled_ccdf, X = calculation_of_ccdf(list_x, ccdf_list, exp_list)

    # Ensure uniform array structure for x and scaled CCDFs
    list_X_uniform = [np.asarray(x) for x in X]
    list_X_scaled_ccdf = [np.asarray(ccdf) for ccdf in scaled_ccdf]

    # Filter out invalid entries
    filtered_X, filtered_scaled_ccdf = [], []
    for x, ccdf in zip(list_X_uniform, list_X_scaled_ccdf):
        if np.all(x == 0):
            print("Warning: Set of X contains only zeros.")
        elif np.isnan(ccdf).all():
            print("Warning: CCDF contains only NaN values.")
        else:
            filtered_X.append(x)
            filtered_scaled_ccdf.append(ccdf)

    # Determine the common range for x
    x_min = min(np.min(x) for x in filtered_X)
    x_max = max(np.max(x) for x in filtered_X)
    x_common = np.linspace(x_min, x_max, num=500)

    # Create interpolation functions
    interp_funcs = [
        interp1d(x, ccdf_scaled, bounds_error=False, fill_value=(0, 0))
        for x, ccdf_scaled in zip(filtered_X, filtered_scaled_ccdf) if np.any(x)
    ]

    # Interpolate y-values based on common x-values
    interpolated_y_values = [f(x_common) for f in interp_funcs]

    return x_common, interpolated_y_values



def find_global_intersections(x_common, y_values):
    """
    Finds global intersection points on the y-values with specified thresholds.

    Parameters:
    ----------
    x_common : array-like
        An array of common mu_line (x-values) used across all curves.
    y_values : list of array-like
        A list of interpolated CCDF values corresponding to the uniform `mu_line` (x_common).

    Returns:
    -------
    tuple
        - intersection1 : array-like
            The x-values where the y-values intersect the threshold of 0.5 times the maximum of the minimum y-values (50% steady limit).
        - intersection2 : array-like
            The x-values where the y-values intersect the threshold of 0.05 times the maximum of the minimum y-values (95% steady limit).
    """
    
    # Calculate the minimum y-values across all curves
    min_y_values = np.min(y_values, axis=0)

    # Define thresholds for the intersections
    threshold1 = 0.5 * np.max(min_y_values)  # 50% steady limit
    threshold2 = 0.05 * np.max(min_y_values)  # 95% steady limit
    
    # Find the x-values where the curves intersect the thresholds
    intersection1 = find_intersection_x_values(x_common, min_y_values, threshold1)
    intersection2 = find_intersection_x_values(x_common, min_y_values, threshold2)

    return intersection1, intersection2


def apply_filter_and_recompute(index, years, global_intersection2):
    """
    Rejection estimation Filter based on a threshold (95% steady limit) and recomputes the data,  applying Poisson curve analysis.

    Parameters:
    ----------
    index : int or tuple
        Pixel index for which the Poisson curve and data extraction will be performed.
    years : list of int
        List of years for which data and Poisson curves are to be analyzed.
    global_intersection2 : float
        The threshold value (95% steady limit) used for filtering based on Poisson curve flux.

    Returns:
    -------
    tuple
        - data_filtered : list
            Data extracted and computed for filtered years.
        - ccdfs_filtered : list
            Complementary cumulative distribution functions (CCDFs) for the filtered data.
        - filtered_years : list of int
            List of years that passed the threshold filter.
    """
    # Set the threshold from global intersection (95% steady limit)
    threshold = global_intersection2

    # Initialize lists to store flux and bounds for each year
    flux1 = []
    upper_bounds = []
    lower_bounds = []

    # Iterate over each year to obtain Poisson curve values
    for year in years:
        # Obtain Poisson curve values (flux, upper bound, lower bound) for the current year and index
        f, ub, lb = obtain_poisson_cruve(year, index)
        
        # Store the results in the respective lists
        flux1.append(f)
        upper_bounds.append(ub)
        lower_bounds.append(lb)

    # Initialize the list to hold filtered years
    filtered_years = []

    # Filter the years based on the threshold
    for i, flux in enumerate(flux1):
        if flux < threshold:
            filtered_years.append(years[i])

    # Extract data and recompute for the filtered years
    data_filtered, processed_years_filtered = extract_data_and_compute_global_calculations(filtered_years, index)

    # Recompute CCDFs for the filtered data
    ccdfs_filtered = compute_ccdfs(data_filtered)

    return data_filtered, ccdfs_filtered, filtered_years







def MAIN(index):
    """
    Main function to extract data, compute global calculations, apply filtering, and plot results.

    Parameters:
    ----------
    index : int
        The pixel index to identify the dataset being processed.
    """

    # Define the main epochs (years)
    years = [2000, 2004, 2012, 2018, 2020]

    # Extract data and compute global calculations
    data, processed_years = extract_data_and_compute_global_calculations(years, index)

    # Compute CCDFs from the data
    ccdfs = compute_ccdfs(data)

    # Scale and interpolate data for finding intersections
    x_common, interpolated_y_values = scale_and_interpolate(data, ccdfs)

    # Find global intersections based on the interpolated CCDFs
    global_intersection1, global_intersection2 = find_global_intersections(x_common, interpolated_y_values)

    # Prepare to filter years based on the 95% threshold from global intersections
    filtered_years = processed_years.copy()  # Copy initial years for filtering
    old_intersections = (global_intersection1, global_intersection2)

    # Apply filtering to remove points above the 95% threshold and recompute data
    data_filtered, ccdfs_filtered, filtered_years = apply_filter_and_recompute(index, filtered_years, global_intersection2)
    print("Filtered year list without the maximum value:", filtered_years)

    # Scale and interpolate the filtered data
    x_common_filtered, interpolated_y_values_filtered = scale_and_interpolate(data_filtered, ccdfs_filtered)

    # Find global intersections for the filtered data
    global_intersection1_filtered, global_intersection2_filtered = find_global_intersections(x_common_filtered, interpolated_y_values_filtered)
    print(index, global_intersection1_filtered, global_intersection2_filtered)

    # Store new intersections for plotting comparison
    new_intersections = (global_intersection1_filtered, global_intersection2_filtered)

    # Plot the results, comparing original vs filtered data
    #plot_result(index, years, filtered_years, data, x_common, interpolated_y_values, x_common_filtered, interpolated_y_values_filtered, old_intersections, new_intersections)

    logging.info(f"Processing index {index}")
    return (index, global_intersection1, global_intersection2, global_intersection1_filtered, global_intersection2_filtered)


'''# Test for one index 
if __name__ == "__main__":
    
    if len(sys.argv) > 1:
        
        i = int(sys.argv[1])
        print(f"The Pixel number : {i}")
        MAIN(i)
    else:
        print("No variable passed as argument. Please provide an index value.")'''


def run_in_parallel():
    indices = range(900)
    results = []
    
    with concurrent.futures.ProcessPoolExecutor() as executor:
        try:
            for result in executor.map(MAIN, indices):
                logging.info(f"Completed index {result[0]}")
                results.append(result)
        except Exception as e:
            logging.error(f"Error occurred: {e}")

    results.sort(key=lambda x: x[0])
    
    # Write sorted results to files
    try:
        with open('unfiltered_intersections.txt', 'w') as unfiltered_file, \
             open('filtered_intersections.txt', 'w') as filtered_file:
            for index, global_intersection1, global_intersection2, global_intersection1_filtered, global_intersection2_filtered in results:
                unfiltered_file.write(f"{index}: {global_intersection1}, {global_intersection2}\n")
                filtered_file.write(f"{index}: {global_intersection1_filtered}, {global_intersection2_filtered}\n")
    except Exception as e:
        logging.error(f"Error writing to files: {e}")

if __name__ == "__main__":
    run_in_parallel()
