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
from mpl_toolkits.axes_grid1 import make_axes_locatable
import matplotlib.patches as mpatches
import pathlib
from scipy.ndimage import gaussian_filter
from mpl_toolkits.axes_grid1.anchored_artists import AnchoredSizeBar

import operator as op
import statistics
from itertools import islice


#from regions import Regions
from astropy.wcs import WCS
#from regions import CircleSkyRegion, PixCoord, CirclePixelRegion

def fmean(data):
    return sum(data) / len(data)



def consecutive(data, stepsize=1):
    return np.split(data, np.where(np.diff(data) != stepsize)[0]+1)





def create_reduced_mask(raw_reg,outfile2):
    row1 = np.array([line.strip() for line in open(raw_reg,'r')])
    row1 = np.delete(row1, [0,1,2])


    col_num, row_num=[],[]
    for xx in row1:
        d=xx[4:-1].split(',')
        #print(d)
        col_num.append(int(d[0]))
        row_num.append(int(d[1]))

    Counts=[]
    for hh in range(1,31):
        counts=op.countOf(row_num,hh)
        Counts.append(counts)

    it = iter(col_num)
    sliced =[list(islice(it, 0, i)) for i in Counts]


    f=consecutive(sliced[0])




    mylist=[]
    for kk in range(len(sliced)):
        ff=consecutive(sliced[kk])
        for ll in range(0,len(ff)):
            row=kk+1
            s=ff[ll]
            length=len(s)
            mean=fmean(s) ##statistic.fmean() only avaialble in python >3.8 version so use a defined function 

            mylist.append((mean,row,length))


        
    os.remove(raw_reg)

    
    outfile2.write('# Region file format: DS9 version 4.1\n')
    outfile2.write('global color=green dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
    outfile2.write('image\n')
    for jj in mylist:
        #print(jj[0],jj[1],jj[2])

        
        outfile2.write('box({},{},{},1,0)\n'.format(jj[0],jj[1],jj[2]))

 


