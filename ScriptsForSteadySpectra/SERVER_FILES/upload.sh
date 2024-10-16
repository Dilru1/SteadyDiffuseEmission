#!/bin/bash

# Remote server details
remote_user="dehiwald"
remote_host="ipag-oar.u-ga.fr"
remote_parent_dir="/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub"
remote_parent_dir2="/user/home/dehiwald/workdir/galactic_center/analysis/"

# Local directory containing files to upload
local_dir="/Volumes/T7/EXCLUDE_SINGLE_PIXEL/SGRB/SERVER_FILES"

# Function to upload files to a subdirectory
upload_files() {
  local remote_subdir="$1"
  local local_subdir="$2"
  local count_map="$3"

  # Create the remote directory if it doesn't exist
  sshpass -p 'cs7asyvJrhY.q6s' ssh "${remote_user}@${remote_host}" "mkdir -p '$remote_subdir'"

  # Upload the files using scp
  files=("$count_map" "reg_row_pix.reg" "box_mask_sky.reg")

  for file in "${files[@]}"; do

    #if [ "$file" == "$count_map"  ]; then
    #  sshpass -p 'cs7asyvJrhY.q6s' scp "$local_subdir/$file" "${remote_user}@${remote_host}:${remote_subdir}/count_maps/"
    #fi

    if [ "$file" == "reg_row_pix.reg" ]; then
      sshpass -p 'cs7asyvJrhY.q6s' scp "$local_subdir/$file" "${remote_user}@${remote_host}:${remote_subdir}/reg_files/"
    fi

    #if [ "$file" == "box_mask_sky.reg" ]; then
    #  sshpass -p 'cs7asyvJrhY.q6s' scp "$local_subdir/$file" "${remote_user}@${remote_host}:${remote_subdir}/reg_files/"
    #fi
  done
}

# Function to upload files to a subdirectory
upload_files2() {
  local remote_subdir="$1"
  local local_subdir="$2"


  # Create the remote directory if it doesn't exist
  #sshpass -p 'cs7asyvJrhY.q6s' ssh "${remote_user}@${remote_host}" "mkdir -p '$remote_subdir'"

  # Upload the files using scp
  files=("$count_map" "reg_row_pix.reg" "box_mask_sky.reg")
  files2=("run_all_2_2.sh" "all_new_command_2.sh")

  for file in "${files2[@]}"; do
    sshpass -p 'cs7asyvJrhY.q6s' scp "$local_subdir/$file" "${remote_user}@${remote_host}:${remote_subdir}"
  done
}




# Loop through each subdirectory

subdirs=("0112971501" "0694640601" "0802410101" "0203930101" "0694641301" "0862471101")

#subdirs=("0862471101")


for subdir in "${subdirs[@]}"; do
  remote_subdir="${remote_parent_dir}/${subdir}"
  local_subdir="${local_dir}/${subdir}/black"

  if [ "$subdir" == "0112971501" ]; then
    upload_files "$remote_subdir" "$local_subdir" "count_map_2000.fits"
    #upload_files2 "$remote_subdir" "$local_subdir" 
    
  fi

  if [ "$subdir" == "0694640601" ]; then
    upload_files "$remote_subdir" "$local_subdir" "count_map_2012.fits"
  fi

  if [ "$subdir" == "0694641301" ]; then
    upload_files "$remote_subdir" "$local_subdir" "count_map_2012.fits"
  fi
  
  if [ "$subdir" == "0203930101" ]; then
    upload_files "$remote_subdir" "$local_subdir" "count_map_2004.fits"
  fi
  if [ "$subdir" == "0802410101" ]; then
    upload_files "$remote_subdir" "$local_subdir" "count_map_2018.fits"
  fi

  if [ "$subdir" == "0862471101" ]; then
    upload_files "$remote_subdir" "$local_subdir" "count_map_2020.fits"
   # upload_files2 "$remote_subdir" "$local_subdir" 
  fi 

done
