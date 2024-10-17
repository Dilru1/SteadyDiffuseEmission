#! /bin/sh -f 

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

evselect table=pnS003-clean.fits filteredset=pnS003-clean-filtered.fits expression='(PI in [500:10000])&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)'
evselect table=mos1S001-clean.fits filteredset=mos1S001-clean-filtered.fits expression='(PI in [500:10000])&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)'
evselect table=mos2S002-clean.fits filteredset=mos2S002-clean-filtered.fits expression='(PI in [500:10000])&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)'


#emosaic_prep pnevtfile=pnS003-clean.fits mos1evtfile=mos1S001-clean.fits mos2evtfile=mos2S002-clean.fits atthkfile=AttHk.ds pseudoexpid=15
emosaic_prep pnevtfile=pnS003-clean-filtered.fits mos1evtfile=mos1S001-clean-filtered.fits mos2evtfile=mos2S002-clean-filtered.fits atthkfile=AttHk.ds pseudoexpid=35



