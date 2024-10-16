
# Steady_DiffuseEmission
This repository contains scripts for extracting steady diffuse X-ray emission from the Galactic Center.


### Part 1: Main Pipeline :Scripts for 6.4 keV Emission - ![Text](https://img.shields.io/badge/Directory-ScriptsFor6.4keVEmission-red)


This directory contains standard science reduction scripts originally developed by **terrier et al. (2018)** for processing XMM-Newton data and generating 6.4 keV mosaics for each epoch.

The scripts of **terrier et al. (2018)** have been modified for Python 3 and adapted to run on the *IPAG computer cluster*. This version used following remote server interactions and change the locations. 


```bash
remote_user="dehiwald"  # replace with actual user
remote_host="ipag-oar.u-ga.fr"
remote_dir="/user/home/dehiwald/workdir/galactic_center/XMM_scripts_python"  # replace with the local directory 
```
Ensure that the following directories are correctly set in each script:

```bash
export WORKDIR=/user/home/dehiwald/workdir/galactic_center/XMM_scripts_python
export DATAPATH=/user/home/dehiwald/workdir/galactic_center/data
export ANAPATH=/user/home/dehiwald/workdir/galactic_center/analysis
```


### Script List (located at `WORKDIR`):
1. **NXSA-Results-1646402050141.txt** : A target observation table for a region of interest (Sgr B) as obtained from the XMM Science Archive.

2. **ssl_download.sh** (New script, 2024): Download and extract ODF of all the observations from the XMM Science Archive to the specified location on the IPAG cluster.

```bash
export DATAPATH=/user/home/dehiwald/workdir/galactic_center/data
```

3. **prep_obs_imalist.py** (New script, 2024) : Generates job IDs as epoch lists and image lists from the observation table at the `WORKDIR`.  

   **Output:**  
   - `SgrbXXXX.list` (where XXXX corresponds to epochs from 2000 to 2020)  
   - `ima-SgrbXXXX.list` (counts images for each observation ID in each epoch)

4. a). **ssl_launch_esas_job_ima_mosa.sh** (Updated from terrier et al. (2018))  
   b). **ssl_setenv_ima.sh** (Updated from terrier et al. (2018))  
   c). **ssl_esas_analysis.sh** (Updated from terrier et al. (2018))  
  
 **Output:**  
   This pipeline processes XMM-Newton observations and generates science products including background counts, exposure, and image count files.


5. `make_mosa_sub.sh` : This script is invoked as the second loop in `ssl_launch_esas_job_ima_mosa.sh` to rebin the original count image and zoom into the required region (e.g., Sgr B). 

Example:

```bash
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
```

6. -----WRITE THE CONTINUM SUBTRACTION PART---------



**Note:**  

1. If `make_mosa_sub.sh`  does not work within `ssl_launch_esas_job_ima_mosa.sh` then skip the command `source $WORKDIR/ssl_esas_analysis.sh  $obs` in LOOP 1 and rerun the  `ssl_launch_esas_job_ima_mosa.sh`. 


2. The scripts were initially written for an older version of SAS (19). Newer versions (21+) require significant modifications. However, the IPAG cluster uses a Dockerized version of SAS that uses the SAS19 compatible version.



### Part 2: Morphology of Steady Emission - ![Text](https://img.shields.io/badge/Directory-ScriptsForSteadyEmission-blue)

This directory contains statistical methods developed by Maica, Gilles, and Dilruwan for extracting steady emission using rebinned continuum-subtracted 6.4 keV XMM-Newton flux maps (rebinned to 30 arcseconds, zoomed into Sgr B). The maps can be found in the **maps_eff/** directory, which is the output from **Part 1**.

### Script List (located in the local/IPAG directory):

The following scripts have been created to extract the steady emission for each pixel in the continuum-subtracted 6.4 keV XMM-Newton maps. These scripts and the **maps_eff/** directory can be uploaded to the IPAG cluster for fast execution.

```markdown
# Project Script Structure

- main.py
  - data.py
  - density_cal.py
  - intersections.py
  - ccdf.py
  - pmf.py
  - plots.py
  - pmf.py
  - plot_steady_maps.py
  - Poisson_Maps.py
```

 **main.py** processes all 900 pixels in parallel. It handles n epochs for each pixel. The script first extracts the data for these n epochs. This inputs include the continuum levels and the total number of photons for each epoch corresponding to that pixel. Then, the script calculates the probability density function (p.d.f.) of the 6.4 keV line using Bayesian probability and subsequently computes the complementary cumulative distribution function (CCDF) as the p.d.f. of the steady emission for each epoch. After obtaining each p.d.f., a minimum curve is obtained to represent the p.d.f of steady emission across all n epochs. The rejection estimation criteria are also applied, and the 50% and 95% values are obtained as estimation of the steady emission.

**Output:**  
This pipeline processes all 900 pixels and creates two text files: 
- `filtered_intersections.txt`: Contains array-like values for the 50% and 95% estimations after rejection.
- `unfiltered_intersections.txt`: Contains array-like values for the 50% and 95% estimations before rejection.

Run *plot_steady_maps.py* to create standard FITS files using these values:

- `mosa_steady_map_50lim_30arcsec.fits`: Represents the FITS values of the 50% steady estimation for the Sgr B region.
- `mosa_steady_map_95lim_30arcsec.fits`: Represents the FITS values of the 95% steady estimation for the Sgr B region.


![Steady Map](Documentation/Images/graph_decreasing_density.png)
*Probability density curves for line emission, represented by dP_total / dμ_line as a function of μ_line, for Pixel_{i=15, j=8} in th*


**Poisson_Maps.py** processes all 900 pixels in each epoch to create Poisson maps. These Poisson maps utilize the density-estimated 6.4 keV flux instead of the continuum-subtracted values and are used to extract the spectrum of the steady emission.

**Note:**

1. Use the following function in **main.py** to test a single epoch:

    ```python
    if __name__ == "__main__":
        if len(sys.argv) > 1:
            i = int(sys.argv[1])
            print(f"The Pixel number: {i}")
            MAIN(i)
        else:
            print("No variable passed as argument. Please provide an index value.")
    ```

2. Also, use:

    ```python
    plot_result(index, years, filtered_years, data, x_common, interpolated_y_values, x_common_filtered, interpolated_y_values_filtered, old_intersections, new_intersections)
    ```

In line:350 in **main.py** for plots. This function will plot the probability density of the 6.4 keV line, the steady emission, the steady emission after applying the rejection criteria, and the Poisson light curve for a single pixel.


![Probability Density Curves](Documentation/Images/graph_rand_density.png)
*Probability density curves for line emission, represented by dP_total / dμ_line as a function of μ_line, for Pixel_{i=15, j=8} in the data cube (see Figure \ref{fig:datacube}) on the left. The probability density curves for the steady emission, or dP_steady / dμ_steady as a function of μ_steady, are represented as the CCDF of the line on the right. The combined density of the steady emission is plotted in black, representing the minimum of each density curve.*

