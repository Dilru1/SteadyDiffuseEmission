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




def create_raw_region(epoch,outfile0,outfile1):
    read_count_map=fits.open(maps_count+'count_map_{}.fits'.format(epoch))[0].data


   

    count_map_95=np.array(read_count_map)
    count_map_95=count_map_95.reshape(30,30)
    #print(count_map_95)




    hdu=fits.open(maps_cut+'mosa-6320-6480_sub_30arcsec_{}.fits'.format(str(epoch)))[0]
    w=WCS(hdu.header)
    
  
    count_index=[]

#FOR MAASK1
    outfile0.write('# Region file format: DS9 version 4.1\n')
    outfile0.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
    outfile0.write('image\n')
    for y, row in enumerate(count_map_95):
        for x, element in enumerate(row):
            if element == 0 :
           
                count_index.append(( (x+1) , (y+1) ))
                outfile0.write('box({},{},1,1,0)'.format((x+1),(y+1) ))
                outfile0.write('\n')

            else : 
                pass


#FOR MAASK2
    outfile1.write('# Region file format: DS9 version 4.1\n')
    outfile1.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
    outfile1.write('image\n')
    outfile1.write('box(15.5,15.5,30,30,0)')






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
                coordinateconv.create_sky_maps(reg_files+'box_mask_sky.reg','pnS003', outfile_1=out1 )

            with open(reg_files+"box_mask_m1_sky.reg", "w") as out1:
                coordinateconv.create_sky_maps(reg_files+'box_mask_sky.reg','mos1S001', outfile_1=out1 )


            with open(reg_files+"box_mask_m2_sky.reg", "w") as out1:
                coordinateconv.create_sky_maps(reg_files+'box_mask_sky.reg','mos1S001', outfile_1=out1 )


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
        