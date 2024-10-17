import numpy as np
np.set_printoptions(suppress=True,
   formatter={'float_kind':'{:f}'.format})

import sys
from astropy.io import fits
from astropy.wcs import WCS
import os
import pathlib
from os import walk



def init():
    # Root - working folder
    global mypath,basepath,obsid
    #mypath=str(pathlib.Path().resolve())+'/'
    basepath='/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub/'
    obsid='0203930101/'
    mypath=basepath+obsid
  
    # Folder conatining the code and the observation list
    global save_path,base_file_path,fits_file_path,reg_files,final_path
    save_path = mypath+'final_reg_fits_mask/'
    final_path = mypath+'/final_masks_fits/'
    base_file_path = mypath+'reg_fits_table/'
    reg_files =mypath+'reg_files/'

    fits_file_path=str(sys.argv[1])+'/'
    #print(fits_file_path)
   


init()


# Check if the directory exists
if not os.path.exists(final_path):
    # If it doesn't exist, create it
    os.makedirs(final_path)

if not os.path.exists(save_path):
    # If it doesn't exist, create it
    os.makedirs(save_path)


# Check if the directory exists
#if not os.path.exists(save_path):
    # If it doesn't exist, create it
#    os.makedirs(save_path)



def create_region_table(fits_file,reg_file,base_reg_fit_file,instr):
	hdu = fits.open(fits_file_path+fits_file)[0]
	hdr_base= hdu.header





	row1 = np.array([line.strip() for line in open(reg_files+reg_file,'r')])
	row1 = np.delete(row1, [0,1,2])
	row_c=len(row1)

	hdul = fits.open(base_file_path+base_reg_fit_file)
	table = hdul[1]
	hdr = table.header
	hdr0=hdul[0].header

	mode=base_reg_fit_file[-8:-5]


	ntable = fits.BinTableHDU.from_columns(table.columns, nrows=row_c,fill=True)
	ntable.writeto(save_path+'temp_table_{}_{}.fits'.format(instr,mode), overwrite=True)

	hdul.close()

	hdul2 = fits.open(save_path+'temp_table_{}_{}.fits'.format(instr,mode), mode='update')
	table2 = hdul2[1]
	hdr2 = table2.header
	hdr2_0=hdul2[0].header

	hdr2['EXTNAME']=hdr['EXTNAME']
	hdr2['HDUVERS']=hdr['HDUVERS']
	hdr2['HDUCLASS']=hdr['HDUCLASS']
	hdr2['HDUCLAS1']=hdr['HDUCLAS1']
	hdr2['HDUCLAS2']=hdr['HDUCLAS2']
	hdr2['MTYPE1']=hdr['MTYPE1']
	hdr2['MFORM1']=hdr['MFORM1']


	hdr2_0['XPROC0']=hdr0['XPROC0']
	hdr2_0['XDAL0']=hdr0['XDAL0']
	hdr2_0['CREATOR']=hdr0['CREATOR']
	hdr2_0['DATE']=hdr0['DATE']
	hdr2_0['LONGSTRN']=hdr0['LONGSTRN']


	#WCS INFORMATION
	hdr2_0['CTYPE1']=hdr_base['CTYPE1']
	hdr2_0['CTYPE2']=hdr_base['CTYPE2']

	hdr2_0['CRVAL1']=hdr_base['CRVAL1']
	hdr2_0['CRVAL2']=hdr_base['CRVAL2']

	hdr2_0['CRPIX1']=hdr_base['CRPIX1']
	hdr2_0['CRPIX1']=hdr_base['CRPIX1']

	hdr2_0['CDELT1']=hdr_base['CDELT1']
	hdr2_0['CDELT2']=hdr_base['CDELT2']

	hdul2.close()




def update_region_table(reg_file,base_reg_fit_file,instr):
	mode=base_reg_fit_file[-8:-5]
	#print(mode)
	hdul0 = fits.open(base_file_path+base_reg_fit_file)
	table0 = hdul0[1]

	hdul1 = fits.open(save_path+'temp_table_{}_{}.fits'.format(instr,mode), mode='update')
	table1 = hdul1[1]

	row1 = np.array([line.strip() for line in open(reg_files+reg_file,'r')])
	row1 = np.delete(row1, [0,1,2])

	
	if mode=='sky':
		a='X'
		b='Y'
		ang=301.28
	if mode=='det':
		a='DETX'
		b='DETY'
		


	for i in range(len(row1)):
		if mode=='sky':
			a='X'
			b='Y'
			ang=301.28
		if mode=='det':
			a='DETX'
			b='DETY'
			ang=float(row1[i][4:-1].split(',')[4])

			#print(instr,mode,ang)
		x_num=float(row1[i][4:-1].split(',')[0])
		s=x_num
		table1.data[i]['SHAPE']='ROTBOX'
		table1.data[i][a][0]=format(x_num, '.12f')
		if mode=='det'and instr=='m1':
			print(s)
		table1.data[i][b][0]=float(row1[i][4:-1].split(',')[1])
		table1.data[i]['R'][0]=float(row1[i][4:-1].split(',')[2])
		table1.data[i]['R'][1]=float(row1[i][4:-1].split(',')[3])
		table1.data[i]['ROTANG'][0]=ang
		table1.data[i]['COMPONENT']=1


	hdul1.close()
	hdul0.close()

	hdul = fits.open(save_path+'temp_table_{}_{}.fits'.format(instr,mode))
	table1 = hdul[1]

	#print(table1.data)



##BIG_MASKS
##END BIG MASKS
fits_f=['pnS003-exp-im.fits','mos1S001-exp-im.fits','mos2S002-exp-im.fits']
#regions_det=['reg_det_pn.reg','reg_det_m1.reg','reg_det_m2.reg']
regions_sky=['reg_sky_pn_data.reg','reg_sky_m1_data.reg','reg_sky_m2_data.reg']

tables_det=['pnS003-bkg_region-det.fits','mos1S001-bkg_region-det.fits','mos2S002-bkg_region-det.fits']
tables_sky=['pnS003-bkg_region-sky.fits','mos1S001-bkg_region-sky.fits','mos2S002-bkg_region-sky.fits']
instr=['pn','m1','m2']

for i in range(3):

	create_region_table(fits_f[i],regions_sky[i],tables_sky[i],instr[i])
	update_region_table(regions_sky[i],tables_sky[i],instr[i])



#os.rename('a.txt', 'b.kml')




def rename_tables():
	filenames = next(walk(save_path), (None, None, []))[2] 
	fits_file = [f for f in os.listdir(save_path) if f.endswith('.fits')]
	for i in fits_file:
		ss=i.split("_")
		if ss[2]=='m1':
			os.rename(save_path+i, final_path+'mos1S001-mask_region-{}.fits'.format(ss[3][0:3]))
		if ss[2]=='m2':
			os.rename(save_path+i, final_path+'mos2S002-mask_region-{}.fits'.format(ss[3][0:3]))
		if ss[2]=='pn':
			os.rename(save_path+i, final_path+'pnS003-mask_region-{}.fits'.format(ss[3][0:3]))



rename_tables()




