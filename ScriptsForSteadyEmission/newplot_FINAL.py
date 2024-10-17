import os
from astropy.io import fits
import sys
import glob
import numpy as np
from scipy.integrate import quad
from scipy.optimize import brentq
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt 
from scipy.integrate import simps
from itertools import compress
import re
from scipy.stats import poisson
import numpy as np 
import math
import random
from scipy.integrate import cumtrapz
import matplotlib.pyplot as plt 
import pathlib
import os
import glob
from matplotlib.ticker import AutoMinorLocator
from astropy.io import fits
from mpl_toolkits.axes_grid1 import make_axes_locatable
import matplotlib.patches as mpatches
import pathlib
from scipy.ndimage import gaussian_filter
from mpl_toolkits.axes_grid1.anchored_artists import AnchoredSizeBar
#anchorpoints
from matplotlib.patches import Ellipse
from matplotlib.patches import Circle
from ds9colormap import new_cmap
#import cv2 as cv
import numpy.ma as ma

from astropy.wcs import WCS
import urllib.request
from scipy.ndimage import gaussian_filter
from astropy.coordinates import SkyCoord
from astropy import units as u
from regions import PixCoord
from regions import CircleSkyRegion, CirclePixelRegion
from matplotlib.colors import ListedColormap


from matplotlib.patches import Ellipse
from matplotlib.patches import Circle
from matplotlib.patches import Rectangle
import pyregion
from astropy.visualization.wcsaxes import WCSAxes



from matplotlib import pyplot as plt
from matplotlib import colors
from matplotlib.patches import Patch
from matplotlib.lines import Line2D

plt.rcParams.update({
    'figure.figsize': (8,6),
    'figure.dpi': 300,
    'font.size': 10,
    'font.family': 'serif',
    'lines.linewidth': 1.5,
    'lines.markersize': 6,
    'axes.labelsize': 10,
    'axes.titlesize': 12,
    'axes.linewidth': 1,
    'xtick.labelsize': 8,
    'ytick.labelsize': 8,
    'xtick.major.size': 3.5,
    'ytick.major.size': 3.5,
    'xtick.minor.size': 2,
    'ytick.minor.size': 2,
    'legend.fontsize': 8,
    'legend.frameon': False,



})


region_file = 'ds9_reg_high.reg'
regions =  pyregion.open(region_file)
def create_label(res, wcsf):
    wcs=WCS(wcsf)

    l=[]
    lat=[]

    if res == 30 :
        x_axis=np.arange(0,res,6)
        y_axis=np.arange(0,res,6)
        lon_end= xcenter + wcsf['CDELT1']*(res/2)
        lon_beg= xcenter - wcsf['CDELT1']*(res/2)

        lat_end= ycenter + wcsf['CDELT2']*(res/2)
        lat_beg= ycenter - wcsf['CDELT2']*(res/2)
        l= list(np.round((np.linspace(lon_beg,lon_end,5)),2))
        lat=list(np.round((np.linspace(lat_beg,lat_end,5)),2))



    del wcs

    return x_axis,l,y_axis,lat  



def create_contour(pixelsize,o,p,objecttype,parameters,wcsf):
    wcs=WCS(wcsf)
    objectcoord=SkyCoord(frame="galactic", l=o, b=p, unit="deg")
    objx, objy = wcs.world_to_pixel(objectcoord)

    if objecttype == 'Circle' :
        return Circle((objx, objy), parameters[0]/pixelsize, color='white',fill=False,linestyle='--' ,linewidth=0.5)

    if objecttype == 'Ellipse' :
        return Ellipse((objx, objy), (parameters[0]*2)/pixelsize,(parameters[1]*2)/pixelsize,(parameters[2]+90), color='white',fill=False,linestyle='--',linewidth=1.0)
     

coordxlist= [0.665,0.738,0.661,0.500,0.565,0.643]
coordylist= [-0.027,-0.098,-0.132,-0.109,-0.117,-0.078]
###################################





def init():
    # Root - working folder
    global mypath
    mypath = '/Users/dehiwald/Desktop/SteadyDiffuseEmission/ScriptsForSteadyEmission/' 
 


    # Folder conatining the code and the observation list
    global flux,maps,maps_cut,poisson_map50
    #flux = mypath+'flux_eff/'
    maps = mypath+ 'maps_eff/'
    maps_cut = mypath+ 'maps_eff/maps_expoCut_eff/'
    #poisson_map50 = mypath+ '10arcsec_minmap/datafiles_50lim/'
    global xcenter,ycenter,onearcsec
    xcenter=0.643
    ycenter=-0.078
    onearcsec=0.000277778
    
    
init()

def load_values_from_file(filename):
    extracted_val=[]
    with open(filename, 'r') as file:
        for line in file:

            # Extract numbers using regular expression
            extracted_numbers = re.findall(r"[\d\.\-e]+", line)
            extracted_val.append(extracted_numbers)

    return extracted_val


###NEWMETHOD_FINAL
#old_method = load_values_from_file('unfiltered_intersections.txt')  # index, flux, error
new_method2 = load_values_from_file('filtered_intersections.txt') # index, flux, error




#OLD METHOD VS NEW2 

def save_filtered_values2(new_method2, output_file):
    index,central_val,upper_val=[],[],[]
    for x in new_method2:
        index.append(x[0])
        central_val.append(float(x[1]))
        upper_val.append(float(x[2]))
        
    return index,central_val,upper_val
            
    

output_file_path = 'oldnew2.txt'
idx,cent,upper= save_filtered_values2(new_method2, output_file_path)

min1_50=np.array(cent)
print("sum of the counts", np.sum(min1_50))

min1_95=np.array(upper)


min1_50=min1_50.reshape(30,30)
min1_95=min1_95.reshape(30,30)

vmin = min(min1_50.min(), min1_95.min())
vmax = max(min1_50.max(), min1_95.max())*0.60


############### SAVE STEADY MAPS AS FITS FILES ##########################################
year='2004'
reference_header=fits.open(maps_cut+'mosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].header 
wcsf=reference_header
fits.writeto('mosa_steady_map_50lim_30arcsec.fits',min1_50,reference_header,overwrite=True) #2000 header data written to the fits file
fits.writeto('mosa_steady_map_95lim_30arcsec.fits',min1_95,reference_header,overwrite=True) #2000 header data written to the fits file
#fits.writeto('velocity_maps.fits',vel_map,reference_header,overwrite=True) #2000 header data written to the fits file
############### SAVE STEADY MAPS AS FITS FILES ##########################################


min1_50=gaussian_filter(min1_50, sigma=1)
min1_95=gaussian_filter(min1_95, sigma=1.5)


fig, (ax1,ax2) = plt.subplots(1,2, figsize=(8,4))
#fig, axs = plt.subplots(2, 2, figsize=(12,8))  # Create a 2x2 grid of subplots








divider1 = make_axes_locatable(ax1)
divider2 = make_axes_locatable(ax2)


cax1 = divider1.append_axes('right', size='3%', pad=0.05 )
cax2 = divider2.append_axes('right', size='3%', pad=0.05)





new_cmap.set_bad(color='green', alpha=0.25)








im1 =ax1.imshow(min1_50, cmap=new_cmap, vmin=vmin,vmax=vmax, origin='lower' )
fig.colorbar(im1, cax=cax1, orientation='vertical')

cb1=fig.colorbar(im1, cax=cax1, orientation='vertical')
cb1.set_label(r'$\mathrm{Fe\ K\alpha\ flux\ [ph\ cm^{-2}\ s^{-1}\ pixel^{-1}]}$', fontsize=8, labelpad=8)


#ax1.set_title(r'Steady Map $ Min_{\lambda_{0.5}}= Min(\lambda_{i})$',fontsize=10.5)
ax1.set_xlabel('Galactic longitude')
ax1.set_ylabel('Galactic latitude')
ax1.xaxis.set_minor_locator(AutoMinorLocator(6))
ax1.yaxis.set_minor_locator(AutoMinorLocator(6))

scalebar2 = AnchoredSizeBar(ax1.transData, 1, r"$50 \% Map$", 9)
ax1.add_artist(scalebar2)

for region in regions:
    shape_list = pyregion.ShapeList([region])
    regimg = shape_list.as_imagecoord(wcsf)
    patch_list, artist_list = regimg.get_mpl_patches_texts()
    for patch in patch_list:
        ax1.add_patch(patch)
    for artist in artist_list:
        ax1.add_artist(artist)


ax1.set_xticks(create_label(30, wcsf)[0])
ax1.set_xticklabels(create_label(30, wcsf)[1] , color='k')
ax1.set_yticks(create_label(30, wcsf)[2])
ax1.set_yticklabels(create_label(30, wcsf)[3])






im2 =ax2.imshow(min1_95, cmap=new_cmap, vmin=vmin,vmax=vmax, origin='lower' )
fig.colorbar(im2, cax=cax2, orientation='vertical')

cb2=fig.colorbar(im2, cax=cax2, orientation='vertical')
cb2.set_label(r'$\mathrm{Fe\ K\alpha\ flux\ [ph\ cm^{-2}\ s^{-1}\ pixel^{-1}]}$', fontsize=8, labelpad=8)


#ax2.set_title(r'Steady Map $ Min_{\lambda_{0.5}}= Min(\lambda_{i})$',fontsize=10.5)
ax2.set_xlabel('Galactic longitude')
ax2.set_ylabel('Galactic latitude')

ax2.xaxis.set_minor_locator(AutoMinorLocator(6))
ax2.yaxis.set_minor_locator(AutoMinorLocator(6))

scalebar2 = AnchoredSizeBar(ax2.transData, 1,r"$95 \% Map$", 9)
ax2.add_artist(scalebar2)

for region in regions:
    shape_list = pyregion.ShapeList([region])
    regimg = shape_list.as_imagecoord(wcsf)
    patch_list, artist_list = regimg.get_mpl_patches_texts()
    for patch in patch_list:
        ax2.add_patch(patch)
    for artist in artist_list:
        ax2.add_artist(artist)


ax2.set_xticks(create_label(30, wcsf)[0])
ax2.set_xticklabels(create_label(30, wcsf)[1] , color='k')
ax2.set_yticks(create_label(30, wcsf)[2])
ax2.set_yticklabels(create_label(30, wcsf)[3])
pixsize = 30
#ax2.add_patch(create_contour(pixsize,coordxlist[0],coordylist[0],'Circle',[120] ,wcsf) )
#ax2.add_patch(create_contour(pixsize,coordxlist[1],coordylist[1],'Ellipse',[150,60,330] ,wcsf))
#ax2.add_patch(create_contour(pixsize,coordxlist[2],coordylist[2],'Ellipse',[144,72,0] ,wcsf))
#ax2.add_patch(create_contour(pixsize,coordxlist[3],coordylist[3],'Circle',[80] ,wcsf))
#ax2.add_patch(create_contour(pixsize,coordxlist[4],coordylist[4],'Circle',[90],wcsf ))
#ax2.add_patch(create_contour(pixsize,coordxlist[5],coordylist[5],'Circle',[410] ,wcsf))





plt.tight_layout() # Or equivalently,  "plt.tight_layout()"
plt.savefig(f'/Users/dehiwald/Desktop/SteadyDiffuseEmission/Documentation/Images/maps.png',bbox_inches='tight')
plt.show()




    

