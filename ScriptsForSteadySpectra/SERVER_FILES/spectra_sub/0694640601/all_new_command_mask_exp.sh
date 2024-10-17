#!/bin/bash

id="0694640601"
epoch="2012"

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



export PFILES=/user/home/dehiwald/pfiles/$id
export SAS_CCFPATH=/user/home/dehiwald/workdir/sasfiles/ccf
export CALDB=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas


export SAS_CCF=${ANAPATH}/${obsid}/ccf.cif
export SAS_ODF=${DATAPATH}/${obsid}/
export MY_ODF=${DATAPATH}/${obsid}/


export SAS_ODF=`pwd`/`ls -1 *SUM.SAS`





cd $WORKDIR


python3 $WORKDIR/python_scripts/2_create_region.py $epoch $ANAPATH/${obsid} 


cd $ANAPATH/${obsid}

ds9tocxc outset=reg_pn_mask.cxc xcolumn=X ycolumn=Y < $WORKDIR/reg_files/reg_sky_pn_data.reg
ds9tocxc outset=reg_m1_mask.cxc xcolumn=X ycolumn=Y < $WORKDIR/reg_files/reg_sky_m1_data.reg
ds9tocxc outset=reg_m2_mask.cxc xcolumn=X ycolumn=Y < $WORKDIR/reg_files/reg_sky_m2_data.reg


#eexpmap attitudeset=atthk.fits eventset=pnS003-clean.fits:EVENTS expimageset=pnS003-exp-im.fits imageset=pnS003-obj-im.fits pimax=10000 pimin=300 withdetcoords=no 
#eexpmap attitudeset=atthk.fits eventset=mos1S001-clean.fits:EVENTS expimageset=mos1S001-exp-im.fits imageset=mos1S001-obj-im.fits pimax=10000 pimin=300 withdetcoords=no 
#eexpmap attitudeset=atthk.fits eventset=mos2S002-clean.fits:EVENTS expimageset=mos2S002-exp-im.fits imageset=mos2S002-obj-im.fits pimax=10000 pimin=300 withdetcoords=no 

#evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0)) &&region(pnS003-bkg_region-sky.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&(PI in [500:10000])' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-obj-im-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400  yimagemin=3401 updateexposure=yes filterexposure=yes ignorelegallimits=yes   
#evselect table=pnS003-clean-oot.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0)) &&region(pnS003-bkg_region-sky.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&(PI in [500:10000])' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-obj-im-500-10000-oot.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400  yimagemin=3401 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
#evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0) &&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7))&&region(mos1S001-bkg_region-sky.fits)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))'  filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-obj-im-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400 yimagemin=3401 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
#evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0) &&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7))&&region(mos2S002-bkg_region-sky.fits)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))'  filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-obj-im-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400 yimagemin=3401 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
 

emask detmaskset=pnS003-mask-im.fits expimageset=pnS003-exp-im.fits  threshold1=0.05 threshold2=5.0     withregionset=yes  regionset=reg_pn_mask.cxc
emask detmaskset=mos1S001-mask-im.fits expimageset=mos1S001-exp-im.fits  threshold1=0.05 threshold2=5.0 withregionset=yes  regionset=reg_m1_mask.cxc
emask detmaskset=mos2S002-mask-im.fits expimageset=mos2S002-exp-im.fits  threshold1=0.05 threshold2=5.0 withregionset=yes  regionset=reg_m2_mask.cxc


eexpmap attitudeset=atthk.fits eventset=pnS003-clean.fits:EVENTS   expimageset=pnS003-exp-im-500-10000.fits   imageset=pnS003-obj-im-500-10000.fits    pimax=10000 pimin=500 withdetcoords=no 
eexpmap attitudeset=atthk.fits eventset=mos1S001-clean.fits:EVENTS expimageset=mos1S001-exp-im-500-10000.fits imageset=mos1S001-obj-im-500-10000.fits  pimax=10000 pimin=500 withdetcoords=no 
eexpmap attitudeset=atthk.fits eventset=mos2S002-clean.fits:EVENTS expimageset=mos2S002-exp-im-500-10000.fits imageset=mos2S002-obj-im-500-10000.fits  pimax=10000 pimin=500 withdetcoords=no 


emask detmaskset=pnS003-mask-im-500-10000.fits expimageset=pnS003-exp-im-500-10000.fits threshold1=0.05 threshold2=5.0 withregionset=yes  regionset=reg_pn_mask.cxc
emask detmaskset=mos1S001-mask-im-500-10000.fits expimageset=mos1S001-exp-im-500-10000.fits threshold1=0.05 threshold2=5.0 withregionset=yes  regionset=reg_m1_mask.cxc
emask detmaskset=mos2S002-mask-im-500-10000.fits expimageset=mos2S002-exp-im-500-10000.fits threshold1=0.05 threshold2=5.0 withregionset=yes  regionset=reg_m2_mask.cxc
  
python3 $WORKDIR/python_scripts/merge_mask.py $ANAPATH/${obsid} 






