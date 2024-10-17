#!/bin/bash

id="0112971501"
epoch="2000"

export DATAPATH=/user/home/dehiwald/workdir/galactic_center/data
export ANAPATH=/user/home/dehiwald/workdir/galactic_center/analysis
export WORKDIR=/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub/$id
cd $ANAPATH

export obsid=$id

echo "--------------------------------------------"
echo "Starting spectral analysis"
echo "--------------------------------------------"
echo "Processing ObsID :" $obsid
echo "--------------------------------------------"


mkdir ${obsid}
cd ${obsid}

rm *.dat *.txt

export PFILES=/user/home/dehiwald/pfiles/$id
export SAS_CCFPATH=/user/home/dehiwald/workdir/sasfiles/ccf
export CALDB=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas


export SAS_CCF=${ANAPATH}/${obsid}/ccf.cif
export SAS_ODF=${DATAPATH}/${obsid}/
export MY_ODF=${DATAPATH}/${obsid}/

##### Start XMM analysis
#cifbuild withccfpath=no analysisdate=now category=XMMCCF calindexset="$SAS_CCF" fullpath=yes
#odfingest odfdir=$SAS_ODF outdir=.

export SAS_ODF=`pwd`/`ls -1 *SUM.SAS`


#epchain  odfaccess=all
#epchain  odfaccess=all withoutoftime=true
#emchain

#pn-filter
#mos-filter





cd $WORKDIR


#python scripts

#python3 $WORKDIR/python_scripts/1_create_region.py $epoch $ANAPATH/${obsid}
output=$(python3 $WORKDIR/python_scripts/1_create_region.py $epoch $ANAPATH/${obsid} | grep -Eo '[+-]?[0-9]+([.][0-9]+)? [+-]?[0-9]+([.][0-9]+)? [+-]?[0-9]+([.][0-9]+)?')

# Use read to split the filtered output into RA and Dec
read -r ra dec theta <<< "$output"

echo "RA: $ra, Dec: $dec"

cd $ANAPATH/${obsid}
conv_reg mode=3  imagefile=pnS003-obj-image-sky.fits  ra=$ra dec=$dec shape=ELLIPSE semimajor=0.1  semiminor=0.1 rotangle=$theta  >> angle.txt
conv_reg mode=3  imagefile=mos1S001-obj-image-sky.fits  ra=$ra dec=$dec shape=ELLIPSE semimajor=0.1  semiminor=0.1 rotangle=$theta >> angle.txt
conv_reg mode=3  imagefile=mos2S002-obj-image-sky.fits  ra=$ra dec=$dec shape=ELLIPSE semimajor=0.1  semiminor=0.1 rotangle=$theta >> angle.txt



source region_coord_pn.sh
source region_coord_m1.sh
source region_coord_m2.sh
source region_big.sh


source_dir=$ANAPATH/${obsid}
destination_dir="/user/home/dehiwald/workdir/galactic_center/analysis/spectra_sub/$id/reg_files_det"

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



source $WORKDIR/ssl_esas_analysis_mosa.sh 


