import numpy as np 
import matplotlib.pyplot as plt 
from astropy.io import fits
from ds9colormap import new_cmap
from mpl_toolkits.axes_grid1.axes_divider import make_axes_locatable
import matplotlib
import matplotlib.colors as mplcolors
from mpl_toolkits.axes_grid1.inset_locator import InsetPosition
import os
import numpy as np
from astropy.io import fits
import matplotlib.pyplot as plt
from astropy.visualization import astropy_mpl_style
from matplotlib.colors import LogNorm
from astropy.wcs import WCS
#from reproject import reproject_interp
from matplotlib.gridspec import GridSpec
from matplotlib.gridspec import GridSpec
from astropy import units as u
from mpl_toolkits.axes_grid1.axes_divider import make_axes_locatable
from ds9colormap import new_cmap
import matplotlib.axes as maxes
import os
#import pyregion
from matplotlib import cbook
from mpl_toolkits.axes_grid1 import AxesGrid
import matplotlib as mpl
from matplotlib.patches import Polygon
from astropy.visualization.wcsaxes import WCSAxes
import matplotlib
import matplotlib.ticker as ticker
from astropy.coordinates import SkyCoord  # High-level coordinates
from astropy.coordinates import ICRS, Galactic, FK4, FK5  # Low-level frames
from astropy.coordinates import Angle, Latitude, Longitude  # Angles
import astropy.units as u
import matplotlib.colors as mplcolors
from reproject import reproject_interp
import pyregion
from mpl_toolkits.axes_grid1.inset_locator import zoomed_inset_axes, mark_inset
from scipy.stats import gaussian_kde

from visual import adjust_font_size
from visual import adjust_visual_params




fig_width = 12
fig_height = 5


def update_plt_settings(fig_width, fig_height):
    font_size = adjust_font_size(fig_width, fig_height)
    visual_params = adjust_visual_params(fig_width, fig_height)
    
    plt.rcParams.update({
        "font.family": "serif",
        'font.size': font_size,
        'axes.labelsize': font_size,
        'xtick.labelsize': font_size * 0.8,
        'ytick.labelsize': font_size * 0.8,
        "legend.fontsize": font_size * 0.5,
        "legend.frameon": True,
        **visual_params  # Merge the dynamically calculated visual parameters
    })


update_plt_settings(fig_width, fig_height)



def init():
    # Root - working folder
    global mypath
    mypath = '/Users/dehiwald/Desktop/morphgit/SteadyDiffuseEmission/ScriptsForSteadyEmission/maps_eff/' 



    global flux,maps,maps_cut,poisson_map50
    #flux = mypath+'flux_eff/'
    maps = mypath+ 'maps_eff/'
    maps_cut = mypath
   
init()


def fmt(x, pos):
    a, b = '{:.1e}'.format(x).split('e')
    b = int(b)
    if b == 0 :
        return 0 
    else :
        return r'${} \times 10^{{{}}}$'.format(a, b)

def set_margins(fig, margins):
    """Set figure margins as [left, right, top, bottom] in inches from the edges of the figure."""
    left, right, top, bottom = margins
    width, height = fig.get_size_inches()
    
    # Convert to figure coordinates
    left, right = left / width, 1 - right / width
    bottom, top = bottom / height, 1 - top / height

    try:
        # Attempt to set margins using subplots_adjust
        fig.subplots_adjust(left=left, bottom=bottom, right=right, top=top)
    except Exception as e:
        # Handle any exceptions (e.g., invalid margin values or layout conflicts)
        print(f"An error occurred while setting margins: {e}")


def create_galactic_labels(header, naxis):
    """
    Create custom labels for a 2D array plot in galactic coordinates.

    :param header: A dictionary containing FITS header information.
    :param naxis: Size of the array (width, height).
    :return: Two lists of labels, one for the x-axis (GLON) and one for the y-axis (GLAT).
    """
    # Extracting necessary header information
    crval1 = header['CRVAL1']  # Reference values (GLON, GLAT)
    crval2 = header['CRVAL2']


    crpix1 = header['CRPIX1']  # Reference pixel coordinates
    crpix2 = header['CRPIX2']  # Reference pixel coordinates
    

    cdelt1 = header['CDELT1']  
    cdelt2 = header['CDELT2']  # Degrees per pixel
    naxis1, naxis2 = naxis     # Size of the array

    # Calculate the ranges for each axis
    glon_range = ((np.arange(naxis1) - crpix1 + 1) * cdelt1) + crval1
    glat_range = ((np.arange(naxis2) - crpix2 + 1) * cdelt2) + crval2

    return glon_range, glat_range



year='2020'

flux = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].data
header =head = fits.open(maps_cut + 'mosa-6320-6480_sub_30arcsec_{}.fits'.format(year))[0].header
#head = fits.open('/Users/dehiwald/Desktop/THESIS/CHAPTER3/2dmaps/PROJECT/maps_eff/' + '{}.fits'.format(year))[0].header
data = np.load(f'data_{year}.npy', allow_pickle=True)

fits.writeto('Poisson_Maps_30arcsec_{}.fits'.format(year),data,header,overwrite=True) 

#flux[np.isinf(flux)] = np.nan
#data[np.isinf(data)] = np.nan


mins=[np.min(flux), np.min(data)]
maxs=[np.max(flux), np.max(data)]

print(maxs)




fig = plt.figure(figsize=(fig_width, fig_height)) #, constrained_layout=True)
set_margins(fig,[1,0.1,0.2,1.2])
#Set figure margins as [left, right, top, bottom] in inches from the edges of the figure."""

ax1 = plt.subplot2grid((1, 3), (0, 0))  # First subplot in the first column
ax2 = plt.subplot2grid((1, 3), (0, 1))  # Second subplot in the second column
ax3 = plt.subplot2grid((1, 3), (0, 2))  # Third subplot in the third column

im1=ax1.imshow(flux, origin='lower', cmap=new_cmap, vmin=min(mins), vmax=max(maxs)*0.80)

naxis = (30, 30)  # Size of the array
  # Size of the array
glon_labels, glat_labels = create_galactic_labels(head, naxis)
num_ticks = 5  # Adjust this value as needed
glon_ticks = np.linspace(0, len(glon_labels)-1, num_ticks, dtype=int)
glat_ticks = np.linspace(0, len(glat_labels)-1, num_ticks, dtype=int)

# Set the ticks and their labels on the axes
ax1.set_xticks(glon_ticks)
ax1.set_xticklabels([f"{val:.2f}°" for val in glon_labels[glon_ticks]])
ax1.set_yticks(glat_ticks)
ax1.set_yticklabels([f"{val:.2f}°" for val in glat_labels[glat_ticks]])


ax1.tick_params(axis='both', which='major', labelsize=12)
ax1.minorticks_on()
ax1.xaxis.set_minor_locator(ticker.AutoMinorLocator())
ax1.yaxis.set_minor_locator(ticker.AutoMinorLocator())


ax1.set_ylabel(r'Galactic Latitude',  fontsize=12)
ax1.set_xlabel(r'Galactic Longitude',  fontsize=12)




ax1.text(0.05, 0.95, r'6.4 keV Map', transform=ax1.transAxes, fontsize=14, 
         verticalalignment='top', fontweight='bold', color='white',
         bbox=dict(facecolor='black', edgecolor='none', boxstyle='round,pad=0.1'))




im2=ax2.imshow(data, origin='lower', cmap=new_cmap, vmin=min(mins), vmax=max(maxs)*0.80)

naxis = (30, 30)  # Size of the array
  # Size of the array
glon_labels, glat_labels = create_galactic_labels(head, naxis)
num_ticks = 5  # Adjust this value as needed
glon_ticks = np.linspace(0, len(glon_labels)-1, num_ticks, dtype=int)
glat_ticks = np.linspace(0, len(glat_labels)-1, num_ticks, dtype=int)



# Set the ticks and their labels on the axes
ax2.set_xticks(glon_ticks)
ax2.set_xticklabels([f"{val:.2f}°" for val in glon_labels[glon_ticks]])
ax2.set_yticks(glat_ticks)
ax2.set_yticklabels([f"{val:.2f}°" for val in glat_labels[glat_ticks]])


ax2.tick_params(axis='both', which='major', labelsize=12)
ax2.minorticks_on()
ax2.xaxis.set_minor_locator(ticker.AutoMinorLocator())
ax2.yaxis.set_minor_locator(ticker.AutoMinorLocator())

#ax2.set_ylabel(r'Galactic Latitude',  fontsize=12)
ax2.set_xlabel(r'Galactic Longitude',  fontsize=12)

ax2.text(0.05, 0.95, r'50 $\%$ Map', transform=ax2.transAxes, fontsize=14, 
         verticalalignment='top', fontweight='bold', color='white',
         bbox=dict(facecolor='black', edgecolor='none', boxstyle='round,pad=0.1'))


left = ax1.get_position().x0
bottom = ax1.get_position().y0 - 0.15
  # Adjust this for spacing below the subplots
width = ax2.get_position().x1 - ax1.get_position().x0
height = 0.02  # Adjust as needed

norm2 = mplcolors.Normalize(vmin=min(mins), vmax=max(maxs)*0.80)

# Create new axes for the color bar
cax2 = fig.add_axes([left, bottom, width, height])
cbar2 = fig.colorbar(mpl.cm.ScalarMappable(norm=norm2, cmap=new_cmap), format=ticker.FuncFormatter(fmt), orientation="horizontal", cax=cax2)

# Label, ticks, and formatting for the new color bar


#cbar2.set_label(r' Fulx ($\mathrm{ph\,cm^{-2}\,s^{-1}\,pixel^{-1}}$)',labelpad=10)
cbar2.set_label(r'$\mathrm{Fe\ K\alpha\ flux\ [ph\ cm^{-2}\ s^{-1}\ pixel^{-1}]}$', fontsize=12, labelpad=8)




cbar2.ax.xaxis.set_ticks_position('bottom')
cbar2.ax.xaxis.set_label_position('bottom')
cbar2.ax.tick_params(labelsize=10, rotation=0)

cbar2.ax.yaxis.set_offset_position('right')


a=1e6
flcmap='inferno'
xy = np.vstack([flux.flatten()*a,data.flatten()*a])
z = gaussian_kde(xy)(xy)

print(z)

minflux=np.min(flux.flatten()*a)
maxflux=np.max(flux.flatten()*a)

mindata=np.min(data.flatten()*a)
maxdata=np.max(data.flatten()*a)

scatter=ax3.scatter(flux.flatten()*a,data.flatten()*a, c=z, s=14, marker='v', cmap=flcmap)
ax3.plot([min(minflux, mindata), max(maxflux, maxdata)],  # X range
         [min(minflux, mindata), max(maxflux, maxdata)],  # Y range
         color='black', linestyle='--', linewidth=1)

#ax1_divider = make_axes_locatable(ax3)
#cax3 = ax1_divider.append_axes("right", size="7%", pad="2%")
#cb3 = fig.colorbar(scatter, cax=cax3)
#cb3.set_label(label='Point Density',fontsize=10,labelpad=10)


ax3.set_xlabel(r'$\mathrm{Fe\ K\alpha\ flux\ [10^{-6} \, ph\ cm^{-2}\ s^{-1}\ pixel^{-1}]}$', fontsize=12, labelpad=8)
ax3.set_ylabel(r'$\mathrm{Fe\ K\alpha\ Poisson \, flux\ [10^{-6} \, ph\ cm^{-2}\ s^{-1}\ pixel^{-1}]}$', fontsize=12, labelpad=8)


ax3.ticklabel_format(axis='x', style='sci', useOffset=False)


x1, x2, y1, y2 = -2e-7*a, 1.5e-7*a, -0.8e-7*a, 3e-7*a  # Example ranges, adjust to your needs


#inset_ax = zoomed_inset_axes(ax3, zoom=4, loc='upper left')  # Adjust zoom level and location
inset_ax = ax3.inset_axes([0.1, 0.1, 0.2, 0.2])
ip = InsetPosition(ax3,[0.2, 0.6, 0.3, 0.3])
inset_ax.set_axes_locator(ip)


scatter_min=inset_ax.scatter(flux.flatten()*a, data.flatten()*a, c=z,marker='^',s=8, cmap=flcmap)


# Set the limits for the inset axes based on the region of interest
inset_ax.set_xlim(x1, x2)
inset_ax.set_ylim(y1, y2)


inset_ax.tick_params(axis='both', which='major', labelsize=7)  # Customize label size as needed
inset_ax.tick_params(axis='y', which='both', labelsize=7)



ax3.minorticks_on()
ax3.tick_params(which='minor', direction='in')
ax1.tick_params(which='minor', direction='out')
ax2.tick_params(which='minor', direction='out')

ax3.xaxis.set_minor_locator(ticker.AutoMinorLocator())
ax3.yaxis.set_minor_locator(ticker.AutoMinorLocator())

#plt.subplots_adjust(bottom=0.30)  # Adjust the bottom margin. The value may need tweaking.

plt.tight_layout()
plt.savefig(f'poisson_{year}.pdf',dpi=800)
plt.show()

