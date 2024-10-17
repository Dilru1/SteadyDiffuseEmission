import numpy as np 
import os
from astropy.io import fits
from astropy.wcs import WCS
import matplotlib.pyplot as plt
import pyregion
import pickle
from astropy.coordinates import SkyCoord
from astropy import units as u
from regions import PixCoord
from regions import RectangleSkyRegion, RectanglePixelRegion


def init():
    global mypath,basepath,obsid
    basepath='/user/home/dehiwald/workdir/galactic_center/analysis/'
    obsid='0862471101/'
    mypath=basepath+obsid
  
    
init()



with fits.open(mypath+'pnS003-exp-im.fits') as hdul:
    data = hdul[0].data
    header = hdul[0].header
    wcs = WCS(hdul[0].header)

hdul.close()


# Update non-zero values to 1
data[np.nonzero(data)] = 1

# Save the modified data to a new FITS file
new_hdul = fits.PrimaryHDU(data, header=header)
new_hdul.writeto('pnS003-exp-im_up.fits', overwrite=True)





def multical(pix_y,pix_x,box_list):
	#print(pix_y,pix_x)
	flag = False

	for region_set in box_list:
		is_inside = region_set.inside1(pix_y,pix_x)
		
		if is_inside:
			flag=True 
			break

	if flag:
		return flag
	else:
		return False 


#header_files
f = fits.open("pnS003-exp-im_up.fits")
image_data = f[0].data
#image_data = image_data[300:400,400:500]

region_file = 'reg_row_pix_world.reg'
reg = pyregion.open(region_file)

region_or_list=[]
for region in reg:
	shape_list = pyregion.ShapeList([region])	
	regimg =shape_list.as_imagecoord(f[0].header)
	myfilter = regimg.get_filter()
	region_or_list.append(myfilter)
	



mask_list = []
for y in range(image_data.shape[0]):
	row = []
	for x in range(image_data.shape[1]):
		pixel_value = image_data[y, x]
		if pixel_value == 1.0 :
			result= multical(y, x,region_or_list)
			row.append(result)
			print(result)
		else :
			result=False
			print(result)
			row.append(result)

	

	mask_list.append(row)




with open("area_pn_pix", "wb") as fp:   #Pickling
	pickle.dump(mask_list, fp)



