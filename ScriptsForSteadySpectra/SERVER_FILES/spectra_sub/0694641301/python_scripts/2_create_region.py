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
import coordinateconv
import coordinateconv_data
#import subprocess
import sys

wd = os.getcwd()
os.chdir(wd)




def init():
    # Root - working folder
    global mypath,basepath,obsid
    #mypath=str(pathlib.Path().resolve())+'/'
    basepath='/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub/'
    obsid='0694641301/'
    mypath=basepath+obsid
  


    # Folder conatining the code and the observation list
    global maps_cut,maps_count,reg_files,SAVEPATH
    maps_cut = mypath+'steady_maps/'
    maps_count = mypath+'count_maps/'
    reg_files =mypath+'reg_files/'

    
    SAVEPATH=str(sys.argv[2])+'/'
    print(SAVEPATH)

   
init()


possilities = {"2000":"Analysing epoch 2000", "2004":"Analysing epoch 2004", "2012":"Analysing epoch 2012","2018":"Analysing epoch 2018","2020":"Analysing epoch 2020" } 
choice = ""

###MAIN### 

while True:
    choice=str(sys.argv[1])   #input("Enter the Epoch? " )

    if choice in possilities:
        try:
        #MASK1   
            with open(reg_files+"reg_sky_pn_data.reg", "w") as out1:
                coordinateconv_data.create_sky_maps(reg_files+'reg_row_pix.reg','pnS003', outfile_1=out1 )



            with open(reg_files+"reg_sky_m1_data.reg", "w") as out1:
                coordinateconv_data.create_sky_maps(reg_files+'reg_row_pix.reg','mos1S001', outfile_1=out1 )



            with open(reg_files+"reg_sky_m2_data.reg", "w") as out1:
                coordinateconv_data.create_sky_maps(reg_files+'reg_row_pix.reg','mos2S002', outfile_1=out1 )

                
        except IOError as e:
            print('Operation failed: %s' % e.strerror)


        break
    else:
        print("You should use between 2000,2004,2012,2018,2020")
        