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
#import subprocess
import sys

wd = os.getcwd()
os.chdir(wd)




def init():
    # Root - working folder
    global mypath,basepath,obsid
    #mypath=str(pathlib.Path().resolve())+'/'
    basepath='/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub/'
    obsid='0203930101/'
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
        #with open(reg_files+"reg_single_pix.reg", "w") as out0, open(reg_files+"box_mask_sky.reg", "w") as out1 :
        #    create_raw_region(choice, outfile0=out0, outfile1=out1)
            
        

        #with open(reg_files+"reg_row_pix.reg", "w") as out2:
            
        #    coordinateconv_horiz.create_reduced_mask(reg_files+'reg_single_pix.reg', outfile2=out2)


        try:
            with open(SAVEPATH+'region_coord_pn.sh', 'w') as out3, open(SAVEPATH+'region_coord_m1.sh', 'w') as out4, open(SAVEPATH+'region_coord_m2.sh', 'w') as out5:
                coordinateconv.create_coordinate_conversion_files(choice, reg_files+"reg_row_pix.reg", outfile3=out3,outfile4=out4,outfile5=out5)

            with open(SAVEPATH+'region_big.sh', 'w') as out6:
                coordinateconv.create_coordinate_conversion_files_big(choice,reg_files+"box_mask_sky.reg", outfile6=out6)

        #MASK1   
            with open(reg_files+"reg_sky_pn.reg", "w") as out1:
                coordinateconv.create_sky_maps(reg_files+'reg_row_pix.reg','pnS003', outfile_1=out1 )



            with open(reg_files+"reg_sky_m1.reg", "w") as out1:
                coordinateconv.create_sky_maps(reg_files+'reg_row_pix.reg','mos1S001', outfile_1=out1 )



            with open(reg_files+"reg_sky_m2.reg", "w") as out1:
                coordinateconv.create_sky_maps(reg_files+'reg_row_pix.reg','mos2S002', outfile_1=out1 )
            
            #BOXSKYMAPS
            with open(reg_files+"box_mask_pn_sky.reg", "w") as out1:
                coord=coordinateconv.create_sky_maps(reg_files+'box_mask_sky.reg','pnS003', outfile_1=out1 )

            with open(reg_files+"box_mask_m1_sky.reg", "w") as out1:
                coord=coordinateconv.create_sky_maps(reg_files+'box_mask_sky.reg','mos1S001', outfile_1=out1 )


            with open(reg_files+"box_mask_m2_sky.reg", "w") as out1:
                coord=coordinateconv.create_sky_maps(reg_files+'box_mask_sky.reg','mos1S001', outfile_1=out1 )
                print(coord[0][0],coord[0][1],coord[0][2])
                
        except IOError as e:
            print('Operation failed: %s' % e.strerror)

        #For MASK2
        #try:
        #    with open('region_big.csh', 'w') as out6 :
        #        coordinateconv.create_coordinate_conversion_files_big(choice,"box_mask_sky.reg", outfile6=out6)
        #except IOError as e:
        #    print('Operation failed: %s' % e.strerror)




        break
    else:
        print("You should use between 2000,2004,2012,2018,2020")
        