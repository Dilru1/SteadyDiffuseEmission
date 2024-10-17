import numpy as np 
import os
from astropy.io import fits
import sys
#from regions import Regions
from astropy.wcs import WCS
#from regions import CircleSkyRegion, PixCoord, CirclePixelRegion

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
    basepath='/user/home/dehiwald/workdir/galactic_center/analysis/spectra_multi/'
    obsid='0862471101/'
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


######CREATE SKY MAPS#####
def create_sky_maps(reduced_reg_file,instrid,outfile_1):
    
    row = np.array([line.strip() for line in open(reduced_reg_file,'r')])
    row = np.delete(row, [0,1,2])

    hdu=fits.open(maps_count+'count_map_2020.fits')[0].header
    w=WCS(hdu)
    #print(w)


    #ref_x1, ref_y1 =hdu['CRPIX1L'], hdu['CRPIX2L']
    #ref_x_val1, ref_y_val1 =hdu['CRVAL1L'], hdu['CRVAL2L']
    #ref_x_inc1, ref_y_inc1 =hdu['CDELT1L'], hdu['CDELT2L']


    outfile_1.write('# Region file format: DS9 version 4.1\n')
    outfile_1.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
    outfile_1.write('physical\n')
    for rr in row:
        d=rr[4:-1].split(',')
   

        coord1= float(d[0])
        coord2= float(d[1])


        coord3= float(d[2]) #*600
        coord4= float(d[3]) #*600

        if coord3 > 15000.0 and coord4 > 15000.0:
            coord3= float(d[2]) #*600-25
            coord4= float(d[3]) #*600-25
        else : 
            coord3= float(d[2])
            coord4= float(d[3])



        #pixcoord=PixCoord(x=coord1,y=coord2)
        #X=pixcoord.to_sky(wcs=w).data.lon.deg 
        #Y=pixcoord.to_sky(wcs=w).data.lat.deg
        print(coord1,coord2) 
        #X, Y = w.pixel_to_world(coord1, coord2)
        X, Y = w.all_pix2world(coord1, coord2,1)
        print(X,Y)

        #mypix_x, mypix_y = w.all_world2pix(X, Y, 1)  # Assuming pixel indices start from 1
        #print(mypix_x,mypix_y)


        #pix_value_x1=np.round( (ref_x_val1+(mypix_x-ref_x1)*ref_x_inc1), 3 )
        #pix_value_y1=np.round( (ref_y_val1+(mypix_y-ref_y1)*ref_y_inc1),3 )

        #print(pix_value_x1,pix_value_y1) #,coord3,coord4)
        outfile_1.write('box({},{},{},{},301.28)\n'.format( (X),(Y),(coord3),(coord4)) )

   

    #return pix_value_x1, pix_value_y1




'''
def create_coordinate_conversion_files(epoch,reduced_reg_file, outfile3,outfile4,outfile5):

    row = np.array([line.strip() for line in open(reduced_reg_file,'r')])
    row = np.delete(row, [0,1,2])

    hdu=fits.open(maps_count+'count_map_{}.fits'.format(epoch))[0]
    #fits.open(maps_cut+'mosa-6320-6480_sub_30arcsec_{}.fits'.format(str(epoch)))[0]
    w=WCS(hdu.header)

    for rr in row:
        d=rr[4:-1].split(',')
        #print(d)

        coord1= float(d[0])
        coord2= float(d[1])
        #print(coord1,coord2)
        #pixcoord=PixCoord(x=coord1, y=coord2)
        #X=pixcoord.to_sky(wcs=w).data.lon.deg 
        #Y=pixcoord.to_sky(wcs=w).data.lat.deg 

        X, Y = w.all_pix2world(coord1, coord2, 1)

        #print(X,Y)

        #physicalcoord=create_sky_maps(X,Y,'pnS003-obj-image-sky.fits')


        #print(physicalcoord[0],physicalcoord[1])

        outfile3.write("ecoordconv imageset=pnS003-obj-image-sky.fits x={}  y={} coordtype=eqpos >> reg_pn.dat\n".format(X,Y))
        outfile4.write("ecoordconv imageset=mos1S001-obj-image-sky.fits x={}  y={} coordtype=eqpos >> reg_mos1.dat\n".format(X,Y))
        outfile5.write("ecoordconv imageset=mos2S002-obj-image-sky.fits x={}  y={} coordtype=eqpos >> reg_mos2.dat\n".format(X,Y))


def create_coordinate_conversion_files_big(epoch,big_reg_file, outfile6):
    row = np.array([line.strip() for line in open(big_reg_file,'r')])
    row = np.delete(row, [0,1,2])

    hdu=fits.open(maps_count+'count_map_{}.fits'.format(epoch))[0]
    #fits.open(maps_cut+'mosa-6320-6480_sub_30arcsec_{}.fits'.format(str(epoch)))[0]
    w=WCS(hdu.header)


    for rr in row:
        d=rr[4:-1].split(',')
        #print(d)

        coord1= float(d[0])
        coord2= float(d[1])

        

        #print(coord1,coord2)
        #pixcoord=PixCoord(x=coord1, y=coord2)
        #X=pixcoord.to_sky(wcs=w).data.lon.deg 
        #Y=pixcoord.to_sky(wcs=w).data.lat.deg

        X, Y = w.all_pix2world(coord1, coord2, 1) 



        #print(coord1,coord2)
        outfile6.write("ecoordconv imageset=pnS003-obj-image-sky.fits x={}  y={} coordtype=eqpos >> reg_box1.txt \n".format(X,Y))
        outfile6.write("ecoordconv imageset=mos1S001-obj-image-sky.fits x={}  y={} coordtype=eqpos >> reg_box1.txt \n".format(X,Y))
        outfile6.write("ecoordconv imageset=mos2S002-obj-image-sky.fits x={}  y={} coordtype=eqpos >> reg_box1.txt \n".format(X,Y))

'''


# Example usage
source_folder=SAVEPATH
destination_folder=reg_files_det
extension1='.txt'  
extension2='.dat'  









