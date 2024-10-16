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


####EXTERNAL SCRIPTS
from pmf import global_calculation
from data import extract_data_for_year_and_index
from data import extract_data_flux
from data import obtain_poisson_cruve
from plots import plot_result

from ccdf import calculation_of_ccdf
from ccdf import calculation_of_ccdf_second
from intersections import find_intersection_x_values




parent_directory = '/maps_eff/'
def init():



    global flux,maps,maps_cut,poisson_map50
    maps_cut = 'maps_eff/'
 
init()


def extract_data_for_year_and_index(year):

    exp = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_expo.fits'.format(year))[0].data
    flux = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].data
    flux_err = fits.open(maps_cut + 'Dmosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].data
    line_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_net.fits'.format(year))[0].data
    cont_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_cont.fits'.format(year))[0].data
    bkg_ph = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}_bkg.fits'.format(year))[0].data

    # Flattening the data arrays
    exp1 = exp.flatten()
    line_ph = line_ph.flatten()
    cont_ph = cont_ph.flatten()
    flux = flux.flatten()
    flux_err = flux_err.flatten()
    bkg_ph=bkg_ph.flatten()

    # Define the threshold for Poisson method
    threshold = flux * exp1
    upper_lim = 10

    # Generating the Poisson list
    poisson_list = [i for i in range(len(threshold)) if threshold[i] < upper_lim]
    main_list=list(range(0, len(flux)))
    reggis_list = list(set(main_list) - set(poisson_list))

    arbitaryfluxval=[]
    arbitaryfluxval_med=[]
    arbitaryfluxval_med_upper=[]
    actualfluxval=[]
    Dfluxval=[]

    for k in main_list:
        if k in poisson_list:
            f, lb, ub = obtain_poisson_cruve(year, k)
            print(k,"--->",f,ub)
            arbitaryfluxval_med.append(f)
            arbitaryfluxval_med_upper.append(ub)          

        else : 
            val=flux[k]
            upper_lim=flux[k]+ 0.5*flux_err[k]
            #print(val,upper_lim)
            arbitaryfluxval_med.append(flux[k])
            arbitaryfluxval_med_upper.append(upper_lim)

    
    return arbitaryfluxval_med,arbitaryfluxval_med_upper



year = ['2000', '2004', '2012', '2018', '2020']


for y in year:
    map30, mapupp = np.array(extract_data_for_year_and_index(f'{y}'))
    
    im = map30.reshape(30, 30)
    im2 = mapupp.reshape(30, 30)
    
    # Save the files with the year in the name
    np.save(f'poisson_maps/data_{y}', im)        # Change 'output_directory' to your desired output folder
    np.save(f'poisson_maps/data_upper_{y}', im2)

