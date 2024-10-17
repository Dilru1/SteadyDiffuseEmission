#!/bin/bash

id="0694640601"
epoch="2012"
backup_directory="BACKUP_MAIN"

export DATAPATH=/user/home/dehiwald/workdir/galactic_center/data
export ANAPATH=/user/home/dehiwald/workdir/galactic_center/analysis/parallel
export WORKDIR=/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub/parallel/$id
cd $ANAPATH

export obsid=$id

echo "--------------------------------------------"
echo "Starting spectral analysis"
echo "--------------------------------------------"
echo "Processing ObsID :" $obsid
echo "--------------------------------------------"


mkdir ${obsid}
cd ${obsid}

shopt -s nullglob
rm *.dat *.txt
shopt -u nullglob


export PFILES=/user/home/dehiwald/pfiles/$id
export SAS_CCFPATH=/user/home/dehiwald/workdir/sasfiles/ccf
export CALDB=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas


export SAS_CCF=${ANAPATH}/${obsid}/ccf.cif
export SAS_ODF=${DATAPATH}/${obsid}/
export MY_ODF=${DATAPATH}/${obsid}/


##### Start XMM analysis
if [[ "$1" == "--skip-analysis" ]]; then
  echo "Skipping XMM analysis..."
  export SAS_ODF=`pwd`/`ls -1 *SUM.SAS`
else
  cifbuild withccfpath=no analysisdate=now category=XMMCCF calindexset="$SAS_CCF" fullpath=yes
  odfingest odfdir=$SAS_ODF outdir=.

  export SAS_ODF=`pwd`/`ls -1 *SUM.SAS`

  epchain  odfaccess=all
  epchain  odfaccess=all withoutoftime=true
  emchain  
  pn-filter
  mos-filter
fi


echo "Saving Primary Science product in a BACKUP Directory"

# Check if the backup directory exists, if not, create it
if [ ! -d "$backup_directory" ]; then
  mkdir "$backup_directory"
  echo "Backup directory created: $backup_directory"
fi

# Copy the contents of the obsid directory to the backup directory
echo "Copying contents from $obsid to $backup_directory..."
#cp -r "$ANAPATH/${obsid}"/* "$backup_directory"
echo "Copy completed."



cd $WORKDIR


#python scripts

python3 $WORKDIR/python_scripts/1_create_region.py $epoch $ANAPATH/${obsid}



cd $ANAPATH/${obsid}

source region_coord_pn.sh
source region_coord_m1.sh
source region_coord_m2.sh
source region_big.sh


source_dir=$ANAPATH/${obsid}
destination_dir="/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub/parallel/$id/reg_files_det"

extension1=".txt"
extension2=".dat"
cp "$source_dir"/*"$extension1" "$destination_dir"

echo "Files with extension $extension copied successfully."

cp "$source_dir"/*"$extension2" "$destination_dir"


echo "Files with extension $extension copied successfully."



cd $WORKDIR


python3 $WORKDIR/python_scripts/5_coordinateconv2.py $ANAPATH/${obsid}
python3 $WORKDIR/python_scripts/createbintable_edit.py $ANAPATH/${obsid}
python3 $WORKDIR/python_scripts/createbintable_bigtable.py $ANAPATH/${obsid}


echo "--------------------------------------------"
echo "Current path: $(pwd)"
echo "--------------------------------------------"


cp pn_commands.sh $ANAPATH/${obsid}
cp mos1_comands.sh $ANAPATH/${obsid}
cp mos2_commands.sh $ANAPATH/${obsid}


cd $ANAPATH/${obsid}



