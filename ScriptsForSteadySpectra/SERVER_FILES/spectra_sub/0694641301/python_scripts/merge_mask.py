from scipy.stats import poisson
import numpy as np 
import math
import random
from scipy.integrate import cumtrapz
import matplotlib.pyplot as plt 
import pathlib
import os
import glob
from astropy.io import fits
import pathlib
import re
import sys

def init():
    global SAVEPATH
    SAVEPATH=str(sys.argv[1])+'/'
    print(SAVEPATH)

init()


def mult_mask(exp, mask):
    # Open the exposure FITS file in 'update' mode to modify it directly
    with fits.open(SAVEPATH + exp, mode='update') as exp_hdu:
        exp_data = exp_hdu[0].data 
        
        with fits.open(SAVEPATH + mask) as mask_hdu:
            mask_data = mask_hdu[1].data  

        exp_data *= mask_data  

       
        exp_hdu.flush()  


mult_mask('pnS003-exp-im-500-10000.fits', 'pnS003-mask-im-500-10000.fits')
mult_mask('mos1S001-exp-im-500-10000.fits', 'mos1S001-mask-im-500-10000.fits')
mult_mask('mos2S002-exp-im-500-10000.fits', 'mos2S002-mask-im-500-10000.fits')



