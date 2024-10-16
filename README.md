
# Steady_DiffuseEmission
This repository contains scripts for extracting steady diffuse X-ray emission from the Galactic Center.

### Part 1: Main Pipeline - Directory: `ScriptsFor6.4keVEmission`
This directory contains standard science reduction scripts originally developed by Regis Terrier (2018) for processing XMM-Newton data and generating 6.4 keV mosaics for each epoch.

The scripts by Regis Terrier (2018) have been modified for Python 3 and adapted to run on the IPAG computer cluster.

\```bash
remote_user="dehiwald"  # replace with actual user
remote_host="ipag-oar.u-ga.fr"
remote_dir="/user/home/dehiwald/workdir/galactic_center/XMM_scripts_python"  # replace with the local directory
\```

### Script List:
1. **NXSA-Results-1646402050141.txt**  
   A target observation table for a specified region obtained from the XMM Science Archive.

2. **ssl_download.sh** (New script, 2024)  
   Downloads all the observations from the XMM Science Archive to the specified location on the IPAG cluster.

3. **prep_obs_imalist.py** (New script, 2024)  
   Generates job IDs, epoch lists, and image lists from the observation table.  
   **Output:**  
   - `SgrbXXXX.list` (where XXXX corresponds to epochs from 2000 to 2020)  
   - `ima-SgrbXXXX.list` (counts images for each observation ID in each epoch)

4. **ssl_launch_esas_job_ima_mosa.sh** (Updated Regis Terrier script, 2018)  
   a. **ssl_setenv_ima.sh** (Updated, 2018)  
   b. **ssl_esas_analysis.sh** (Updated, 2018)  
   **Output:**  
   This pipeline processes XMM-Newton observations and generates key science products including background counts, exposure files, and image count files.

### Required Edits for Directory Locations:
Ensure that the following directories are correctly set in each script:


```bash
export WORKDIR=/user/home/dehiwald/workdir/galactic_center/XMM_scripts_python
export DATAPATH=/user/home/dehiwald/workdir/galactic_center/data
export ANAPATH=/user/home/dehiwald/workdir/galactic_center/analysis



### Part B: `make_mosa_sub.sh` Script
This script is invoked as the second loop in `ssl_launch_esas_job_ima_mosa.sh` to rebin the original count image and zoom into the required region (e.g., Sgr B). 

Example:
\```bash
if [ $name == 'SgrB2' ]; then
    ra=266.86174642
    dec=-28.42722147
    angle=58.72

    if [ $rebin == '30arcsec' ]; then
        xsize=40
        ysize=40
        pixel=30
    fi
fi
\```

**Note:**  
The scripts were initially written for an older version of SAS. Newer versions may require significant modifications. However, the IPAG cluster utilizes a Dockerized version of SAS that uses the older compatible version.
