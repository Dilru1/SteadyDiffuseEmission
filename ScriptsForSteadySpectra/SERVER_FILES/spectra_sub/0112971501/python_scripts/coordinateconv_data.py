import numpy as np 
import os
from astropy.io import fits
import sys
#from regions import Regions
from astropy.wcs import WCS
#from regions import CircleSkyRegion, PixCoord, CirclePixelRegion
from math import acos, degrees
import pathlib
import shutil
from pathlib import Path


def copy_files_with_extension(source_folder, destination_folder, extension):
    # Create the destination folder if it doesn't exist
    if not os.path.exists(destination_folder):
        os.makedirs(destination_folder)

    # Copy files with the specified extension from the source folder to the destination folder
    for item in os.listdir(source_folder):
        item_path = os.path.join(source_folder, item)
        if os.path.isfile(item_path) and item.endswith(extension):
            shutil.copy2(item_path, destination_folder)





def init():
    # Root - working folder
    global mypath,basepath,obsid
    #mypath=str(pathlib.Path().resolve())+'/'
    basepath='/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub/'
    obsid='0112971501/'
    mypath=basepath+obsid
  

    # Folder conatining the code and the observation list
    global flux,maps,maps_cut,maps_count,anapath, SAVEPATH,reg_files_det
    maps_cut = mypath+'steady_maps/'
    maps_count = mypath+'count_maps/'
    #anapath='/user/home/dehiwald/workdir/galactic_center/analysis/0203930101/'
    SAVEPATH=str(sys.argv[2])+'/'
    print(SAVEPATH)
    reg_files_det=mypath+'reg_files_det/'

   
init()


def create_sky_maps(reduced_reg_file, instrid, outfile_1):
    row = np.array([line.strip() for line in open(reduced_reg_file, 'r')])
    row = np.delete(row, [0, 1, 2])

    hdu = fits.open(SAVEPATH + '{}-exp-im.fits'.format(str(instrid)))[0].header
    w = WCS(hdu)

    hdu2 = fits.open(maps_count + 'count_map_2000.fits')[0]
    w2 = WCS(hdu2.header)
    rot_matrix = w2.wcs.pc
    theta_radians = acos(rot_matrix[0, 0])
    theta_degrees = 360 - degrees(theta_radians)

    ##rotation angle calculations
    ref_x1, ref_y1 = hdu['CRPIX1L'], hdu['CRPIX2L']
    ref_x_val1, ref_y_val1 = hdu['CRVAL1L'], hdu['CRVAL2L']
    ref_x_inc1, ref_y_inc1 = hdu['CDELT1L'], hdu['CDELT2L']

    outfile_1.write('# Region file format: DS9 version 4.1\n')
    outfile_1.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
    outfile_1.write('image\n')

    coordinates = []  # List to store X, Y coordinates if reduced_reg_file is 'box_mask_sky.reg'
    box1x, box1y = w.all_world2pix(267.2519173,-28.5280240, 1)
    box2x, box2y = w.all_world2pix(266.8949727,-28.1523457, 1)
    box3x, box3y = w.all_world2pix(266.5007769,-28.2848650, 1)
    box4x, box4y = w.all_world2pix(266.6329698,-28.7719728, 1)

    outfile_1.write('box({},{},1472.2698,646.33726,{})\n'.format(box1x, box1y,theta_degrees))
    outfile_1.write('box({},{},370.36432,978.17539,{})\n'.format(box2x, box2y,theta_degrees))
    outfile_1.write('box({},{},667.22154,621.7131,{})\n'.format(box3x, box3y,theta_degrees))
    outfile_1.write('box({},{},778.24541,1077.013,{})\n'.format(box4x, box4y,theta_degrees))
    for rr in row:
        try:
            d = rr[4:-1].split(',')
            print(d)
            coord1 = float(d[0])
            coord2 = float(d[1])
            coord3 = float(d[2]) * 12
            coord4 = float(d[3]) * 12

            X, Y = w2.all_pix2world(coord1, coord2, 1)

            if reduced_reg_file.endswith('box_mask_sky.reg'):  # Check if the file name matches
                coordinates.append((X, Y,theta_degrees))  # Store the X, Y coordinates

            mypix_x, mypix_y = w.all_world2pix(X, Y, 1)

            outfile_1.write('box({},{},{},{},{})\n'.format(mypix_x, mypix_y, coord3, coord4,theta_degrees))
        except ValueError:
            continue

    if reduced_reg_file.endswith('box_mask_sky.reg'):  # Return coordinates if the file name matches
        return coordinates
















