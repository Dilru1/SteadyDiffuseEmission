#!/bin/bash

# Remote server details
remote_user="dehiwald"
remote_host="ipag-oar.u-ga.fr"
remote_parent_dir="/user/home/dehiwald/workdir/steady/code_listing_ipag/"


password='cs7asyvJrhY.q6s'





upload_files() {
  local remote_subdir="$1"
  local local_subdir="$2"
  
  # Loop over each file and upload it
  for file in "${files[@]}"; do
    sshpass -p "$password" scp "${local_subdir}/${file}" "${remote_user}@${remote_host}:${remote_subdir}/${file}"
  done
}



