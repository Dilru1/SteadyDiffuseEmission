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

import sys


def init():
    # Root - working folder
    global mypath,basepath,obsid
    #mypath=str(pathlib.Path().resolve())+'/'
    basepath='/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub/'
    obsid='0862471101/'
    mypath=basepath+obsid
  


    # Folder conatining the code and the observation list
    global maps_cut,maps_count,reg_files,reg_files_det,SAVEPATH
    maps_cut = mypath+'steady_maps/'
    maps_count = mypath+'count_maps/'
    reg_files =mypath+'reg_files/'
    reg_files_det=mypath+'reg_files_det/'

    #SAVEPATH=str(sys.argv[1])+'/'
    #print(SAVEPATH)
   
init()


def create_ccd_id_list(eccord_file,instr) :
    row1 = np.array([line.strip() for line in open(eccord_file,'r')])

    det_id=[]
    for x in range(len(row1)):
        if x % 9 == 0: #changed from 12 to 9 due to and formatting of dat and txt files
            ss = row1[3+x]       #changed from 5 to 3 due to and formatting of dat and txt files
            ss_det = row1[7+x]

            if instr=='pn':

                value= int(ss_det.split(' ', 3)[1])
                if value in (0, 1, 2):
                    det_id.append(1)

                if value in (3, 4, 5):
                    det_id.append(2)

                if value in (6, 7, 8):
                    det_id.append(3)

                if value in (9, 10, 11):
                    det_id.append(4)



            if instr=='m1':
                det_id.append(int(ss_det.split(' ', 3)[1]))

            if instr=='m2':
                det_id.append(int(ss_det.split(' ', 3)[1]))





    #print(det_id)
    unique_values_set = set(det_id)
    unique_values_list = list(unique_values_set)

    # Print the unique values
    #print(unique_values_list)
    return(unique_values_list)


if __name__ == "__main__":
    # Parse arguments from command-line (you can also modify this part)
    import sys
    if len(sys.argv) != 3:
        print("Usage: python ccd_id_list.py <eccord_file> <instrument>")
        sys.exit(1)
    
    eccord_file = sys.argv[1]
    instr = sys.argv[2]

    # Call the function with the provided arguments
    ccd_ids = create_ccd_id_list(eccord_file, instr)
    print(",".join(map(str, ccd_ids)))  # Print the result as a comma-separated string


    

#create_ccd_id_list(reg_files_det+'reg_pn.dat','pn' )
#create_ccd_id_list(reg_files_det+'reg_mos1.dat','m1' )
#create_ccd_id_list(reg_files_det+'reg_mos2.dat','m2' )




