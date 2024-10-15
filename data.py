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
from density_cal import plot_P_total

import os
current_path = os.getcwd()


import os
from astropy.io import fits

# Initialize the current path
current_path = os.getcwd()

def init():
    global maps_cut
    # Location of the 6.4 KeV mosaics
    maps_cut = current_path + '/maps_eff/'

# Call the initialization function
init()

# Print the maps_cut variable to verify the path
print("Maps cut path:", maps_cut)

def extract_data_for_year_and_index(year, index):
    """
    Extracts relevant FITS file data for a given year and pixel index.

    Parameters:
    ----------
    year : int
        The year from which to extract the data.
    index : int
        The pixel index for which the data is extracted.

    Returns:
    -------
    tuple:
        A tuple containing total photon count (`NTOT_test`), estimated continuum (`nc_test`),
        and exposure value (`exps`).
    """
    exp = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_expo.fits'.format(year))[0].data
    flux = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].data
    flux_err = fits.open(maps_cut + 'Dmosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].data
    line_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_net.fits'.format(year))[0].data
    cont_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_cont.fits'.format(year))[0].data
    countstotimag = fits.open(maps_cut + 'mosa-6320-6480_30arcsec_{}_counts.fits'.format(year))[0].data
    bkg_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_bkg.fits'.format(year))[0].data

    # Flatten the data arrays
    exp = exp.flatten()
    countstotimag = countstotimag.flatten()
    line_ph = line_ph.flatten()
    cont_ph = cont_ph.flatten()
    flux = flux.flatten()
    flux_err = flux_err.flatten()
    bkg_ph = bkg_ph.flatten()

    # Total photon is the sum of the photon from the background + line
    NTOT_test = bkg_ph[index] + line_ph[index]

    # Estimation for the continuum 
    nc_test = bkg_ph[index] 
    
    # Exposure for the pixel
    exps = exp[index] 

    return NTOT_test, nc_test, exps 



def obtain_poisson_cruve(year, index):
    """
    Obtains the Poisson curve for a given year and pixel index.

    Parameters:
    ----------
    year : int
        The year from which to extract the data.
    index : int
        The pixel index for which the Poisson curve is computed.

    Returns:
    -------
    tuple:
        A tuple containing the flux values, lower bound, and upper bound of the Poisson curve.
    """

    exp = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_expo.fits'.format(year))[0].data
    flux = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].data
    flux_err = fits.open(maps_cut + 'Dmosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].data
    line_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_net.fits'.format(year))[0].data
    cont_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_cont.fits'.format(year))[0].data
    bkg_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_bkg.fits'.format(year))[0].data
    countstotimag = fits.open(maps_cut + 'mosa-6320-6480_30arcsec_{}_counts.fits'.format(year))[0].data

    # Flattening the data arrays
    exp = exp.flatten()
    countstotimag=countstotimag.flatten()
    line_ph = line_ph.flatten()
    cont_ph = cont_ph.flatten()
    flux = flux.flatten()
    flux_err = flux_err.flatten()
    bkg_ph = bkg_ph.flatten()


    NTOT_test =  bkg_ph[index]+ line_ph[index] 

    nc_test = bkg_ph[index]
    nl_test = line_ph[index]
    mu_Cont = bkg_ph[index]
    expo_value=exp[index]



    #this code to create the Poisson maps 

    flux_vals, lower_b, upper_b = None, None, None

    # Check if expo_value is zero to avoid division by zero
    if expo_value != 0:
        a, b, c = plot_P_total(NTOT_test, mu_Cont)
        
        # Calculate flux values if 'a', 'b', 'c' are not None
        flux_vals = a / expo_value if a is not None else None
        lower_b = b / expo_value if b is not None else None
        upper_b = c / expo_value if c is not None else None
    else:
        # Set flux_vals to 0 if expo_value is 0, assuming a zero exposure means no flux can be calculated
        flux_vals = 0
        lower_b = 0 
        upper_b = 0


    return flux_vals, lower_b, upper_b


def extract_data_flux(year, index):

    exp = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_expo.fits'.format(year))[0].data
    flux = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].data
    flux_err = fits.open(maps_cut + 'Dmosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].data
    line_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_net.fits'.format(year))[0].data
    cont_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_cont.fits'.format(year))[0].data
    bkg_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_bkg.fits'.format(year))[0].data
    countstotimag = fits.open(maps_cut + 'mosa-6320-6480_30arcsec_{}_counts.fits'.format(year))[0].data

    # Flattening the data arrays
    exp = exp.flatten()
    countstotimag=countstotimag.flatten()
    line_ph = line_ph.flatten()
    cont_ph = cont_ph.flatten()
    flux = flux.flatten()
    flux_err = flux_err.flatten()
    bkg_ph = bkg_ph.flatten()

  


  
    return flux[index], flux_err[index]


