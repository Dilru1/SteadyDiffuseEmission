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
    obsid='0694641301/'
    mypath=basepath+obsid
  


    # Folder conatining the code and the observation list
    global maps_cut,maps_count,reg_files,reg_files_det,SAVEPATH
    maps_cut = mypath+'steady_maps/'
    maps_count = mypath+'count_maps/'
    reg_files =mypath+'reg_files/'
    reg_files_det=mypath+'reg_files_det/'

    SAVEPATH=str(sys.argv[1])+'/'
    print(SAVEPATH)
   
init()



def create_region_files_det(eccord_file,instr,row_count_file=reg_files+'reg_row_pix.reg' ) :
    row1 = np.array([line.strip() for line in open(eccord_file,'r')])
    row1 = np.delete(row1, [-1])
    
    #print(row1)
    print(len(row1))

    row2 = np.array([line.strip() for line in open(row_count_file,'r')])
    row2 = np.delete(row2, [0,1,2])
    

    

    df=open('reg_{}_temp.reg'.format(instr),'w')
    for x in range(len(row1)):
        if x % 9 == 0: #changed from 12 to 9 due to and formatting of dat and txt files
            ss = row1[3+x]   #changed from 5 to 3 due to and formatting of dat and txt files
          
            ss2=ss.split(' ', 3)
            print(ss2)
          
            coord1= float(ss2[2])
            coord2= float(ss2[3])

      
   
            df.write('box({},{},600,600,58.72)\n'.format(coord1,coord2))

    df.close()


    row3 = np.array([line.strip() for line in open('reg_{}_temp.reg'.format(instr),'r')])
    #row3=np.delete(row3,[-1])

    df2=open(reg_files+'reg_det_{}.reg'.format(instr),'w')
    df2.write('# Region file format: DS9 version 4.1\n')
    df2.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
    df2.write('detector\n')
    for (xx,hh) in zip( range(len(row2)), range(len(row3))):
        box_par=row2[xx]
        #print(box_par)
        box_info=row3[hh]

        box_dim=int(box_par[4:-1].split(',')[2])*12*50 + 10
        #print(box_dim)
        box_coord_x=np.round(float(box_info[4:-1].split(',')[0]),3)
        box_coord_y=np.round(float(box_info[4:-1].split(',')[1]),3)
        #print(box_coord_x,box_coord_y)
        

        if instr=='m1':
            df2.write('box({},{},{},615,148.72)\n'.format(box_coord_x,box_coord_y,box_dim))
        else :
            df2.write('box({},{},{},615,58.72)\n'.format(box_coord_x,box_coord_y,box_dim))



    df2.close()


    os.remove('reg_{}_temp.reg'.format(instr)) 


def create_box_region_files_det(eccord_file,instr ) :
    row1 = np.array([line.strip() for line in open(eccord_file,'r')])
    #print(row1)
    #print(len(row1))

    #row2 = np.array([line.strip() for line in open(row_count_file,'r')])
    #row2 = np.delete(row2, [0,1,2])

    detx,dety= [],[]

    for xx in range(len(row1)):
        if xx % 9 == 0:
            #print(row1[xx+5])
            ss = row1[3+xx]
            ss2=ss.split(' ', 3)
            coord1= float(ss2[2])
            coord2= float(ss2[3])
            detx.append(coord1)
            dety.append(coord2)
            #print(coord1,coord2)


    if instr=='pn':
        x1=detx[0]
        y1=dety[0]
        ang=58.72

    if instr=='m1':
        x1=detx[1]
        y1=dety[1]
        ang=148.72

    if instr=='m2':
        x1=detx[2]
        y1=dety[2]
        ang=58.72


    

    df1=open(reg_files+'box_mask_{}_det.reg'.format(instr),'w')
    df1.write('# Region file format: DS9 version 4.1\n')
    df1.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
    df1.write('detector\n')
    df1.write('box({},{},17980,17980,{})'.format(x1,y1,ang))
    df1.close()

    


create_region_files_det(reg_files_det+'reg_pn.dat','pn',row_count_file=reg_files+'reg_row_pix.reg' )
create_region_files_det(reg_files_det+'reg_mos1.dat','m1',row_count_file=reg_files+'reg_row_pix.reg' )
create_region_files_det(reg_files_det+'reg_mos2.dat','m2',row_count_file=reg_files+'reg_row_pix.reg' )


create_box_region_files_det(reg_files_det+'reg_box1.txt' , 'pn' )
create_box_region_files_det(reg_files_det+'reg_box1.txt' , 'm1' )
create_box_region_files_det(reg_files_det+'reg_box1.txt' , 'm2' )


