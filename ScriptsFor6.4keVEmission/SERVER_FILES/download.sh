#!/bin/bash

# Remote server details

remote_user="dehiwald"
remote_host="ipag-calc1.u-ga.fr"
remote_parent_dir="/user/home/dehiwald/workdir/galactic_center/analysis"


# Local directory to store downloaded files
local_dir="/Volumes/T7/EXCLUDE_SINGLE_PIXEL/SGRB/SERVER_FILES/DOWNLOAD"


# Function to download files from a subdirectory
download_files() {
  local remote_subdir="$1"
  local local_subdir="$2"
  local regdir="$3"


  # Create the local directory if it doesn't exist
  mkdir -p "$local_subdir"

  # Download the file using scp
  files_pn=("pnS003.rmf" "pnS003.arf" "pnS003-obj.pi" "pnS003-back.pi" "pnS003-obj-im-500-10000.fits" "pnS003-back-im-det-500-10000.fits")
  files_mos1=("mos1S001.rmf" "mos1S001.arf" "mos1S001-obj.pi" "mos1S001-back.pi" "mos1S001-obj-im-500-10000.fits" "mos1S001-back-im-det-500-10000.fits")
  files_mos2=("mos2S002.rmf" "mos2S002.arf" "mos2S002-obj.pi" "mos2S002-back.pi" "mos2S002-obj-im-500-10000.fits" "mos2S002-back-im-det-500-10000.fits")

  for file in "${files_mos1[@]}"; do
    sshpass -p 'cs7asyvJrhY.q6s' scp "${remote_user}@${remote_host}:${remote_subdir}/$file" "$local_subdir"
  done
  for file in "${files_mos2[@]}"; do
   sshpass -p 'cs7asyvJrhY.q6s' scp "${remote_user}@${remote_host}:${remote_subdir}/$file" "$local_subdir"
  done
  for file in "${files_pn[@]}"; do
    sshpass -p 'cs7asyvJrhY.q6s' scp "${remote_user}@${remote_host}:${remote_subdir}/$file" "$local_subdir"
  done

  sshpass -p 'cs7asyvJrhY.q6s' scp -r "${remote_user}@${remote_host}:$regdir" "$local_subdir"

}

# Loop through each subdirectory
#subdirs=("0112971501" "0694640601" "0802410101" "0203930101" "0694641301")
#subdirs=("0694640601" "0203930101")

subdirs=("0862471101")

for subdir in "${subdirs[@]}"; do
  remote_subdir="${remote_parent_dir}/${subdir}"
  local_subdir="${local_dir}/${subdir}"
  reg_file_dir="${remote_parent_dir}/spectra_sub/${subdir}/reg_files"
  download_files "$remote_subdir" "$local_subdir" "$reg_file_dir"
done