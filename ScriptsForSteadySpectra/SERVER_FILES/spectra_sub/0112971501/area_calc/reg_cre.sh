#!/bin/bash


id="0862471101"
epoch="2020"


export DATAPATH=/user/home/dehiwald/workdir/galactic_center/data
export ANAPATH=/user/home/dehiwald/workdir/galactic_center/analysis
export WORKDIR=/user/home/dehiwald/workdir/galactic_center/analysis/spectra_multi/$id

cd $WORKDIR

export obsid=$id

#python scripts

python3 $WORKDIR/area_calc/1_create_region.py $epoch $ANAPATH/${obsid}



