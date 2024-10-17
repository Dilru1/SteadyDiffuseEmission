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

cd ${obsid}

export PFILES=/user/home/dehiwald/pfiles/$id
export SAS_CCFPATH=/user/home/dehiwald/workdir/sasfiles/ccf
export CALDB=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas

export SAS_CCF=${ANAPATH}/${obsid}/ccf.cif
export SAS_ODF=${DATAPATH}/${obsid}/
export MY_ODF=${DATAPATH}/${obsid}/

export SAS_ODF=`pwd`/`ls -1 *SUM.SAS`

# Define a function to run the commands using GNU Parallel
run_command() {
    source $ANAPATH/${obsid}/$1 ${obsid}
}

# Export the function to make it available to GNU Parallel
export -f run_command

# Run the commands in parallel using GNU Parallel
parallel run_command ::: "pn_commands.sh" "mos1_comands.sh" "mos2_commands.sh"

# The script will continue here after all commands are done.
echo "All spectral analysis commands have finished."
