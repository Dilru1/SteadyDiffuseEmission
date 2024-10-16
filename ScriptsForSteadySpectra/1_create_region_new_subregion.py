import numpy as np 
import matplotlib.pyplot as plt 
import os
import glob
from astropy.io import fits
import pathlib
import shutil
from pathlib import Path
from astropy.wcs import WCS
import pyregion
import sys

wd = os.getcwd()
os.chdir(wd)






fl_2000=fits.open(maps_cut+'mosa-6320-6480_sub_30arcsec_{}.fits'.format('2000'))[0].header
fl_2004=fits.open(maps_cut+'mosa-6320-6480_sub_30arcsec_{}.fits'.format('2004'))[0].header
fl_2012=fits.open(maps_cut+'mosa-6320-6480_sub_30arcsec_{}.fits'.format('2012'))[0].header
fl_2018=fits.open(maps_cut+'mosa-6320-6480_sub_30arcsec_{}.fits'.format('2018'))[0].header
fl_2020=fits.open(maps_cut+'mosa-6320-6480_sub_30arcsec_{}.fits'.format('2020'))[0].header



# List the file paths of the NPY files
file_paths = ["npyfiles/50_limit_Flux_map_2000.npy", "npyfiles/50_limit_Flux_map_2004.npy", "npyfiles/50_limit_Flux_map_2012.npy", "npyfiles/50_limit_Flux_map_2018.npy", "npyfiles/50_limit_Flux_map_2020.npy"]
file_paths_95 = ["npyfiles/95_limit_Flux_map_2000.npy", "npyfiles/95_limit_Flux_map_2004.npy", "npyfiles/95_limit_Flux_map_2012.npy", "npyfiles/95_limit_Flux_map_2018.npy", "npyfiles/95_limit_Flux_map_2020.npy"]



fits.writeto(lim50   + 'mosa-poisson_sub_30arcsec_{}_poisson_50.fits'.format('2000'),np.load(file_paths[0]),fl_2000,overwrite=True) 
fits.writeto(lim95   + 'mosa-poisson_sub_30arcsec_{}_poisson_95.fits'.format('2000'),np.load(file_paths_95[0]),fl_2000,overwrite=True) 

fits.writeto(lim50   + 'mosa-poisson_sub_30arcsec_{}_poisson_50.fits'.format('2004'),np.load(file_paths[1]),fl_2004,overwrite=True) 
fits.writeto(lim95   + 'mosa-poisson_sub_30arcsec_{}_poisson_95.fits'.format('2004'),np.load(file_paths_95[1]),fl_2004,overwrite=True) 



fits.writeto(lim50   + 'mosa-poisson_sub_30arcsec_{}_poisson_50.fits'.format('2012'),np.load(file_paths[2]),fl_2012,overwrite=True) 
fits.writeto(lim95   + 'mosa-poisson_sub_30arcsec_{}_poisson_95.fits'.format('2012'),np.load(file_paths_95[2]),fl_2012,overwrite=True) 



fits.writeto(lim50   + 'mosa-poisson_sub_30arcsec_{}_poisson_50.fits'.format('2018'),np.load(file_paths[3]),fl_2018,overwrite=True) 
fits.writeto(lim95   + 'mosa-poisson_sub_30arcsec_{}_poisson_95.fits'.format('2018'),np.load(file_paths_95[3]),fl_2018,overwrite=True) 



fits.writeto(lim50   + 'mosa-poisson_sub_30arcsec_{}_poisson_50.fits'.format('2020'),np.load(file_paths[4]),fl_2020,overwrite=True) 
fits.writeto(lim95   + 'mosa-poisson_sub_30arcsec_{}_poisson_95.fits'.format('2020'),np.load(file_paths_95[4]),fl_2020,overwrite=True) 

