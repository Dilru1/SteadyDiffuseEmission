import numpy as np 
import matplotlib.pyplot as plt 
import os
from astropy.io import fits
from pathlib import Path

# Define the root working directory
wd = os.getcwd()
os.chdir(wd)

def init():
    """
    Initializes the root folder and required subdirectories for storing maps, counts, 
    and other relevant files. Creates the necessary directories if they do not exist.
    """
    global mypath
    mypath = '/Users/dehiwald/Desktop/SteadyDiffuseEmission/ScriptsForSteadyEmission/'  # Change the root folder

    # Define paths for maps, counts, and Poisson limit data
    global flux, maps, maps_cut, poisson_map50
    maps = os.path.join(mypath, 'maps_eff/')
    maps_cut = os.path.join(maps, 'maps_expoCut_eff/')

    global lim50, lim95, c_map, upload_dir
    lim50 = os.path.join(mypath, 'poisson_maps/')
    
    # Define paths for count maps and server upload files
    c_map = os.path.join(wd, 'count_files/')
    upload_dir = os.path.join(wd, 'SERVER_FILES/')

    # Create directories if they don't exist
    os.makedirs(c_map, exist_ok=True)
    os.makedirs(upload_dir, exist_ok=True)

init()

# List the paths to the Poisson map FITS files for different epochs
file_paths = [
    os.path.join(lim50, "Poisson_Maps_30arcsec_2000.fits"),
    os.path.join(lim50, "Poisson_Maps_30arcsec_2004.fits"),
    os.path.join(lim50, "Poisson_Maps_30arcsec_2012.fits"),
    os.path.join(lim50, "Poisson_Maps_30arcsec_2018.fits"),
    os.path.join(lim50, "Poisson_Maps_30arcsec_2020.fits")
]

# Epoch labels
epochs = ["2000", "2004", "2012", "2018", "2020"]

# Load the steady map 95% upper limit
minmap_95 = fits.open(os.path.join(mypath, 'mosa_steady_map_95lim_30arcsec.fits'))[0].data
counts = np.zeros_like(minmap_95)  # Initialize counts array to store comparison results

# Loop through each epoch and file, compare with minmap_95 and write masked count maps
for file_path, epoch in zip(file_paths, epochs):
    # Read data and header from the FITS file for each epoch
    data = fits.open(file_path)[0].data
    header = fits.open(file_path)[0].header

    # Update counts based on whether data is below the minmap_95 threshold
    counts += (data < minmap_95).astype(int)
    mask_array = np.where(data > minmap_95, 0, 1)

    # Write the mask array into a new FITS file for the current epoch
    fits.writeto(os.path.join(c_map, f'count_map_{epoch}.fits'), mask_array, header, overwrite=True)

#### Save in upload directory ####

# List of directories to be created inside the upload directory
dir_list = ["0112971501", "0203930101", "0694640601", "0694641301", "0802410101", "0862471101"]

# Create directories inside the upload folder if they don't exist
for dir_name in dir_list:
    full_path = os.path.join(upload_dir, dir_name)
    
    if not os.path.exists(full_path):
        os.makedirs(full_path)
        print(f"Directory '{dir_name}' created.")
    else:
        print(f"Directory '{dir_name}' already exists.")

# Define the paths for each epoch and corresponding directories
paths = [os.path.join(upload_dir, dir_name) + '/' for dir_name in dir_list]
epoch_dis = ["2000", "2004", "2012", "2012", "2018", "2020"]

# Loop through each epoch and path to update count maps
for epoch, path in zip(epoch_dis, paths):
    # Load count map data and header for the current epoch
    count_map_path = os.path.join(c_map, f'count_map_{epoch}.fits')
    count_map_data = fits.open(count_map_path)[0].data
    count_map_header = fits.open(count_map_path)[0].header

    # Update the count map data where counts equal 1 (meaning the threshold wasn't exceeded)
    count_map_data[counts == 1] = 0

    # Write the updated count map to the corresponding directory
    fits.writeto(os.path.join(path, f'count_map_{epoch}.fits'), count_map_data, count_map_header, overwrite=True)
