#!/bin/bash

id="0203930101"
epoch="2004"
backup_directory="BACKUP_MAIN"

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

cd ${obsid}


export PFILES=/user/home/dehiwald/pfiles/$id
export SAS_CCFPATH=/user/home/dehiwald/workdir/sasfiles/ccf
export CALDB=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas


export SAS_CCF=${ANAPATH}/${obsid}/ccf.cif
export SAS_ODF=${DATAPATH}/${obsid}/
export MY_ODF=${DATAPATH}/${obsid}/

export SAS_ODF=`pwd`/`ls -1 *SUM.SAS`

source $ANAPATH/${obsid}/pn_commands.sh ${obsid}
source $ANAPATH/${obsid}/mos1_comands.sh ${obsid}
source $ANAPATH/${obsid}/mos2_commands.sh ${obsid}
