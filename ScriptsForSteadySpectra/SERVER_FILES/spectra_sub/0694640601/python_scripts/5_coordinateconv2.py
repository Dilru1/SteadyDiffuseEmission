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
    # Root - working folder
    global mypath,basepath,obsid
    #mypath=str(pathlib.Path().resolve())+'/'
    basepath='/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub/'
    obsid='0694640601/'
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

    #readangle# pn,m1,m2
    angle = reg_files_det + 'angle.txt'
    with open(angle, 'r') as file:
        file_content = file.read()
    pattern = r'\bELLIPSE\s+[-\d.]+\s+[-\d.]+\s+[-\d.]+\s+[-\d.]+\s+([-\d.]+)'
    matches = re.findall(pattern, file_content)
    angle_values = [float(match) for match in matches]
    

    row2 = np.array([line.strip() for line in open(row_count_file,'r')])
    row2 = np.delete(row2, [0,1,2])
    
    #pattern = r"DETX: DETY: ([-\d.]+) ([-\d.]+)"
    detx_dety_values = [] 
    

    with open(eccord_file, 'r') as file:
        for line_number, line in enumerate(file, 1):
            try:
                detx, dety = map(float, line.split())
                detx_dety_values.append((detx, dety))
            except ValueError as e:
                continue
                #print(f"Skipping line {line_number}: {line.strip()} - Error: {e}")


    df=open('reg_{}_temp.reg'.format(instr),'w')
    for x in detx_dety_values:
        coord1= x[0]
        coord2= x[1]
        df.write('box({},{},600,600,0)\n'.format(coord1,coord2))

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

        box_dim=int(box_par[4:-1].split(',')[2])*12*50 #+ 10
        #print(box_dim)
        box_coord_x=np.round(float(box_info[4:-1].split(',')[0]),3)
        box_coord_y=np.round(float(box_info[4:-1].split(',')[1]),3)
        #print(box_coord_x,box_coord_y)
        

        if instr=='m1':
            df2.write('box({},{},{},600,{})\n'.format(box_coord_x,box_coord_y,box_dim,angle_values[1]))
        else :
            df2.write('box({},{},{},600,{})\n'.format(box_coord_x,box_coord_y,box_dim,angle_values[0]))



    df2.close()


    os.remove('reg_{}_temp.reg'.format(instr)) 


def create_box_region_files_det(eccord_file,instr,row_count_file ) :


    #readangle# pn,m1,m2
    angle = reg_files_det + 'angle.txt'
    with open(angle, 'r') as file:
        file_content = file.read()
    pattern = r'\bELLIPSE\s+[-\d.]+\s+[-\d.]+\s+[-\d.]+\s+[-\d.]+\s+([-\d.]+)'
    matches = re.findall(pattern, file_content)
    angle_values = [float(match) for match in matches]
    


    row2 = np.array([line.strip() for line in open(row_count_file,'r')])
    row2 = np.delete(row2, [0,1,2])
    pattern = r"box\(\d+\.\d+,\d+\.\d+,(\d+\.\d+),(\d+\.\d+),"
    dim_values = []

    for item in row2:
        match = re.search(pattern, item)
        
        if match:
            dim_values.append((float(match.group(1))*12*50, float(match.group(2))*12*50 ))

    #pattern = r"DETX: DETY: ([-\d.]+) ([-\d.]+)"
    detx_dety_values = [] 
    

    with open(eccord_file, 'r') as file:
        for line_number, line in enumerate(file, 1):
            try:
                detx, dety = map(float, line.split())
                print(detx,dety)
                detx_dety_values.append((detx, dety))
            except ValueError as e:
                continue
                #print(f"Skipping line {line_number}: {line.strip()} - Error: {e}")
    print(detx_dety_values)
    if instr == 'pn':
        ang = angle_values[0]
        with open(reg_files+'box_mask_{}_det.reg'.format(instr), 'w') as df1:
            df1.write('# Region file format: DS9 version 4.1\n')
            df1.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
            df1.write('detector\n')
            df1.write(f'box({detx_dety_values[0][0]},{detx_dety_values[0][1]},{dim_values[0][0]},{dim_values[0][1]},{ang})\n')


    elif instr == 'm1':
        ang = angle_values[1]
        with open(reg_files+'box_mask_{}_det.reg'.format(instr), 'w') as df1:
            df1.write('# Region file format: DS9 version 4.1\n')
            df1.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
            df1.write('detector\n')
            df1.write(f'box({detx_dety_values[1][0]},{detx_dety_values[1][1]},{dim_values[0][0]},{dim_values[0][1]},{ang})\n')


    elif instr == 'm2':
        ang = angle_values[2]
        with open(reg_files+'box_mask_{}_det.reg'.format(instr), 'w') as df1:
            df1.write('# Region file format: DS9 version 4.1\n')
            df1.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
            df1.write('detector\n')
            df1.write(f'box({detx_dety_values[2][0]},{detx_dety_values[2][1]},{dim_values[0][0]},{dim_values[0][1]},{ang})\n')

        with open(reg_files+'reg_{}.txt'.format(instr), 'w') as df1:
            df1.write(f'&&((DETX,DETY) IN circle({detx_dety_values[2][0]},{detx_dety_values[2][1]},450)')


    else:
        raise ValueError("Instrument not recognized.")

    



create_region_files_det(reg_files_det+'reg_pn.dat','pn',row_count_file=reg_files+'reg_row_pix.reg' )
create_region_files_det(reg_files_det+'reg_mos1.dat','m1',row_count_file=reg_files+'reg_row_pix.reg' )
create_region_files_det(reg_files_det+'reg_mos2.dat','m2',row_count_file=reg_files+'reg_row_pix.reg' )


create_box_region_files_det(reg_files_det+'reg_box1.txt' , 'pn', row_count_file=reg_files+'box_mask_sky.reg' )
create_box_region_files_det(reg_files_det+'reg_box1.txt' , 'm1', row_count_file=reg_files+'box_mask_sky.reg' )
create_box_region_files_det(reg_files_det+'reg_box1.txt' , 'm2', row_count_file=reg_files+'box_mask_sky.reg' )

