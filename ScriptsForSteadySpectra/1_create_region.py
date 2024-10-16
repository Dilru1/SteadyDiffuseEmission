import numpy as np 
import matplotlib.pyplot as plt 
import os
import glob
from astropy.io import fits
import pathlib
import shutil
from pathlib import Path
from astropy.wcs import WCS
import coordinateconv_horiz
import sys

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






def create_raw_region(epoch,outfile0):
    read_count_map=fits.open(c_map+'count_map_{}.fits'.format(epoch))[0].data
    hdu=fits.open(c_map+'count_map_{}.fits'.format(epoch))[0].header
    w=WCS(hdu)
    
  
    count_index=[]

#FOR MAASK1
    outfile0.write('# Region file format: DS9 version 4.1\n')
    outfile0.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
    outfile0.write('image\n')
    for y, row in enumerate(read_count_map):
        for x, element in enumerate(row):
            if element == 0 :
           
                count_index.append(( (x+1) , (y+1) ))
                outfile0.write('box({},{},1,1,0)'.format((x+1),(y+1) ))
                outfile0.write('\n')

            else : 
                pass


     

epochs=["2000","2004","2012","2018","2020"]

for epoch in epochs:
    with open(upload_dir + "/reg_single_{}.reg".format(epoch), "w") as out0:
        create_raw_region(epoch, outfile0=out0)






####SAVE IN UPLOD DIRECTORY 
dir_lis=["0112971501","0203930101","0694640601","0694641301","0802410101","0862471101"]

for dir_name in dir_lis:
    # Create the full path by joining upload_dir and dir_name
    full_path = os.path.join(upload_dir, dir_name)
    
    # Check if the directory exists
    if not os.path.exists(full_path):
        # If it doesn't exist, create the directory
        os.makedirs(full_path)
        print(f"Directory '{dir_name}' created.")
    else:
        print(f"Directory '{dir_name}' already exists.")

        

path_2000=upload_dir+'/'+dir_lis[0]+'/'
path_2004=upload_dir+'/'+dir_lis[1]+'/'
path_2012_1=upload_dir+'/'+dir_lis[2]+'/'
path_2012_2=upload_dir+'/'+dir_lis[3]+'/'
path_2018=upload_dir+'/'+dir_lis[4]+'/'
path_2020=upload_dir+'/'+dir_lis[5]+'/'

epoch_dis=["2000","2004","2012","2012","2018","2020"]
path_dis=[path_2000,path_2004,path_2012_1,path_2012_2,path_2018,path_2020]

for epoch,path in zip(epoch_dis,path_dis):
    with open(path+"reg_row_pix.reg", "w") as out2:
        coordinateconv_horiz.create_reduced_mask(upload_dir + "/reg_single_{}.reg".format(epoch), outfile2=out2)



