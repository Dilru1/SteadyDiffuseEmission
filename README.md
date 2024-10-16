# Steady_DiffuseEmission
This repository contains the script for extracting steady diffuse X-ray emission from the Galactic Center. 


Part 1 : Main pipeline : Directory ScriptsFor6.4keVEmission
This directory contains the standard science reduction scripts developed by Regis terrier (2018)
For reduction of XMM newton data to create 6.4 keV mosaics for each epoch. 

The Regis terrier (2018) scripts are being modified to for python3 and to execute in IPAG computer cluster 

\\bash
remote_user="dehiwald" #replace user 
remote_host="ipag-oar.u-ga.fr"
remote_dir="/user/home/dehiwald/workdir/galactic_center/XMM_scripts_python" #replace local directory 


Script listing 
1. NXSA-Results-1646402050141.txt #Target observation table within a region obtained from XMM Science archive 
 
2.ssl_download.sh #New scrips 2024 ( download all the observations from science argive to the given location in Ipag cluster) 

2. prep_obs_imalist.py #New scrips 2024 ( create jobs id epoch list and image list from the table) 
--output 
SgrbXXXX.list (XXXX is epochs 2000....2020)
ima-SgrbXXXX.list (count images for each observation id in each epoch)


3. a) ssl_launch_esas_job_ima_mosa.sh #Regis terrier (2018) (updated) script
a.1) ssl_setenv_ima.sh #Regis terrier (2018) (updated) script	
a.2) ssl_esas_analysis.sh #Regis terrier (2018) (updated) script	
-output
Run Standard pipeline of the XMM newton observations and create main science products bkg count, file, exposure files , image count file 

Edit the main directory locations in each script
export WORKDIR=/user/home/dehiwald/workdir/galactic_center/XMM_scripts_python
export DATAPATH=/user/home/dehiwald/workdir/galactic_center/data
export ANAPATH=/user/home/dehiwald/workdir/galactic_center/analysis


B) make_mosa_sub.sh script is called as the second loop in the ssl_launch_esas_job_ima_mosa.sh to rebin the original count image and to zoomed in to required region ( for example Sgr B) 
if [ $name=='SgrB2' ];
then
	ra=266.86174642
    dec=-28.42722147
    angle=58.72

    if [ $rebin=='30arcsec' ];
    then
    	xsize=40
        ysize=40
        pixel=30
    fi
fi


Note : the code are written to older SAS version , never version required major modifications in the text. However docker SAS is being used in the IPAG cluster uses the older version 
