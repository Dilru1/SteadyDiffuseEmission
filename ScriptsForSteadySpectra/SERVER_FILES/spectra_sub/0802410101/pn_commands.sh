#! /bin/sh -f  


export DATAPATH=/user/home/dehiwald/workdir/galactic_center/data
export ANAPATH=/user/home/dehiwald/workdir/galactic_center/analysis
#export WORKDIR=/user/home/dehiwald/workdir/galactic_center/spectra_new

cd $ANAPATH

export obsid=$1

echo "--------------------------------------------"
echo "Starting spectral analysis"
echo "--------------------------------------------"
echo "Processing ObsID :" $obsid
echo "--------------------------------------------"



cd ${obsid}



evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(PI in [500:8000])&&(DETY in [-16510:14345])' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-obj-im.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400 yimagemin=3401 updateexposure=yes filterexposure=yes verbosity=1


#STANDARD MASK
atthkgen atthkset=atthk.fits timestep=1 
eexpmap attitudeset=atthk.fits eventset=pnS003-clean.fits:EVENTS expimageset=pnS003-exp-im.fits imageset=pnS003-obj-im.fits pimax=10000 pimin=300 withdetcoords=no 
emask detmaskset=pnS003-mask-im.fits expimageset=pnS003-exp-im.fits threshold1=0.01 threshold2=5.0 





evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((FLAG & 0x762a097c) == 0)&&!((DETX,DETY) IN circle(-2200,-1110,18200))' filtertype=expression keepfilteroutput=yes updateexposure=yes  filterexposure=yes filteredset=pnS003-corn.fits
   
evselect table=pnS003-clean-oot.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((FLAG & 0x762a097c) == 0)&&!((DETX,DETY) IN circle(-2200,-1110,18200))' filtertype=expression keepfilteroutput=yes updateexposure=yes  filterexposure=yes filteredset=pnS003-corn-oot.fits
   
eexpmap attitudeset=atthk.fits eventset=pnS003-clean.fits:EVENTS expimageset=pnS003-exp-im.fits imageset=pnS003-obj-im.fits pimax=10000 pimin=300 withdetcoords=no 
   

evselect table=pnS003-clean-oot.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [400:7200])&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) IN circle(-2200,-1110,17980))&&region(pnS003-bkg_region-sky.fits)&&region(box_table_pn_sky.fits)' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-obj-im-oot.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400 yimagemin=3401 updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12)) &&((DETX,DETY) IN circle(-2200,-1110,17980))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-obj-im-sp-det.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes filtertype=expression expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [500:10000])&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0)) &&((DETX,DETY) IN circle(-2200,-1110,17980))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-obj-im-det-500-10000.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes 
   
eexpmap attitudeset=atthk.fits eventset=pnS003-clean.fits:EVENTS expimageset=pnS003-exp-im-det-500-10000.fits imageset=pnS003-obj-im-det-500-10000.fits withdetcoords=yes pimax=10000 pimin=500 withdetcoords=yes 
   
#emask detmaskset=pnS003-mask-im-det-500-10000.fits expimageset=pnS003-exp-im-det-500-10000.fits threshold1=0.01 threshold2=5.0 
   
evselect table=pnS003-clean-oot.fits:EVENTS withfilteredset=yes filtertype=expression expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [500:10000])&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0)) &&((DETX,DETY) IN circle(-2200,-1110,17980))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-obj-im-det-500-10000-oot.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) IN circle(-2200,-1110,17980))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=pnS003-obj.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-obj.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes 
evselect table=pnS003-clean-oot.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) IN circle(-2200,-1110,17980))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=pnS003-obj-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479
   
backscale spectrumset=pnS003-obj-oot.pi badpixlocation=pnS003-clean-oot.fits withbadpixcorr=yes 
rmfgen format=var rmfset=pnS003.rmf spectrumset=pnS003-obj.pi threshold=1.0e-6 
   
evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) IN circle(-2200,-1110,17980))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=detmap.ds squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=60 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=60 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes 
   
arfgen arfset=pnS003.arf spectrumset=pnS003-obj.pi withrmfset=yes rmfset=pnS003.rmf extendedsource=yes modelee=no withbadpixcorr=no detmaptype=dataset detmaparray=detmap.ds  badpixlocation=pnS003-clean.fits modelootcorr=no 
   
evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0)) &&region(pnS003-bkg_region-sky.fits)&&region(box_table_pn_sky.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&(PI in [500:10000])' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-obj-im-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400  yimagemin=3401 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=pnS003-clean-oot.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7)||(CCDNR == 8)||(CCDNR == 9)||(CCDNR == 10)||(CCDNR == 11)||(CCDNR == 12))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0)) &&region(pnS003-bkg_region-sky.fits)&&region(box_table_pn_sky.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&(PI in [500:10000])' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-obj-im-500-10000-oot.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400  yimagemin=3401 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
eexpmap attitudeset=atthk.fits eventset=pnS003-clean.fits:EVENTS expimageset=pnS003-exp-im-500-10000.fits imageset=pnS003-obj-im-500-10000.fits pimax=10000 pimin=500 withdetcoords=no 
   
#emask detmaskset=pnS003-mask-im-500-10000.fits expimageset=pnS003-exp-im-500-10000.fits threshold1=0.05 threshold2=5.0
   
evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0)) &&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=pnS003-1obj.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479
   
backscale spectrumset=pnS003-1obj.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes 
   
evselect table=pnS003-clean-oot.fits:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0)) &&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=pnS003-1obj-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479
   
backscale spectrumset=pnS003-1obj-oot.pi badpixlocation=pnS003-clean-oot.fits withbadpixcorr=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&!((DETX,DETY) IN circle(-2200,-1110,18200))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-1oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-1oc.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=pnS003-corn-oot.fits:EVENTS expression='(PATTERN <= 4)&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&!((DETX,DETY) IN circle(-2200,-1110,18200))' filtertype=expression withfilteredset=yes keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-1oc-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-1oc-oot.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes  ignoreoutoffov=no
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='((PI in [600:1300])||(PI in [1650:7200]))&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='((PI in [600:1300])||(PI in [1650:7200]))&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PI in [600:1300])&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PI in [1650:7200])&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='(PI in [600:1300])&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='(PI in [1650:7200])&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz withfilteredset=yes withspectrumset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' spectrumset=pnS003-1ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-1ff.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes withspectrumset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' spectrumset=pnS003-1ff-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-1ff-oot.pi badpixlocation=pnS003-clean-oot.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&((FLAG & 0x762a097c)==0)&&!((DETX,DETY) IN circle(-2200,-1110,18200))&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-1fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-1fc.pi withbadpixcorr=yes  badpixlocation=pnS003-clean.fits ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&((FLAG & 0x762a097c)==0)&&!((DETX,DETY) IN circle(-2200,-1110,18200))&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-1fc-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-1fc-oot.pi withbadpixcorr=yes  badpixlocation=pnS003-clean.fits ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [500:10000])&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-im1-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
farith pnS003-im1-500-10000.fits 'pnS003-mask-im-det-500-10000.fits[MASK]' pnS003-im1-500-10000-mask.fits MUL copyprime=yes 
   
mv pnS003-im1-500-10000-mask.fits pnS003-im1-500-10000.fits
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [500:10000])&&((DETX,DETY) in BOX(-10241.5,7115.0,8041.5,8210.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-im1-500-10000-oot.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
farith pnS003-im1-500-10000-oot.fits 'pnS003-mask-im-det-500-10000.fits[MASK]' pnS003-im1-500-10000-mask-oot.fits MUL copyprime=yes 
   
mv pnS003-im1-500-10000-mask-oot.fits pnS003-im1-500-10000-oot.fits
   
evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0)) &&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=pnS003-2obj.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479
   
backscale spectrumset=pnS003-2obj.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes 
   
evselect table=pnS003-clean-oot.fits:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0)) &&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=pnS003-2obj-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479
   
backscale spectrumset=pnS003-2obj-oot.pi badpixlocation=pnS003-clean-oot.fits withbadpixcorr=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&!((DETX,DETY) IN circle(-2200,-1110,18200))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-2oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-2oc.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=pnS003-corn-oot.fits:EVENTS expression='(PATTERN <= 4)&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&!((DETX,DETY) IN circle(-2200,-1110,18200))' filtertype=expression withfilteredset=yes keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-2oc-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-2oc-oot.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes  ignoreoutoffov=no
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='((PI in [600:1300])||(PI in [1650:7200]))&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='((PI in [600:1300])||(PI in [1650:7200]))&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PI in [600:1300])&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PI in [1650:7200])&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='(PI in [600:1300])&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='(PI in [1650:7200])&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz withfilteredset=yes withspectrumset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' spectrumset=pnS003-2ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-2ff.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes withspectrumset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' spectrumset=pnS003-2ff-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-2ff-oot.pi badpixlocation=pnS003-clean-oot.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&((FLAG & 0x762a097c)==0)&&!((DETX,DETY) IN circle(-2200,-1110,18200))&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-2fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-2fc.pi withbadpixcorr=yes  badpixlocation=pnS003-clean.fits ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&((FLAG & 0x762a097c)==0)&&!((DETX,DETY) IN circle(-2200,-1110,18200))&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-2fc-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-2fc-oot.pi withbadpixcorr=yes  badpixlocation=pnS003-clean.fits ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [500:10000])&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-im2-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
farith pnS003-im2-500-10000.fits 'pnS003-mask-im-det-500-10000.fits[MASK]' pnS003-im2-500-10000-mask.fits MUL copyprime=yes 
   
mv pnS003-im2-500-10000-mask.fits pnS003-im2-500-10000.fits
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [500:10000])&&((DETX,DETY) in BOX(5840.0,7115.0,8040.0,8210.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-im2-500-10000-oot.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
farith pnS003-im2-500-10000-oot.fits 'pnS003-mask-im-det-500-10000.fits[MASK]' pnS003-im2-500-10000-mask-oot.fits MUL copyprime=yes 
   
mv pnS003-im2-500-10000-mask-oot.fits pnS003-im2-500-10000-oot.fits
   
evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0)) &&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=pnS003-3obj.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479
   
backscale spectrumset=pnS003-3obj.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes 
   
evselect table=pnS003-clean-oot.fits:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0)) &&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=pnS003-3obj-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479
   
backscale spectrumset=pnS003-3obj-oot.pi badpixlocation=pnS003-clean-oot.fits withbadpixcorr=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&!((DETX,DETY) IN circle(-2200,-1110,18200))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-3oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-3oc.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=pnS003-corn-oot.fits:EVENTS expression='(PATTERN <= 4)&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&!((DETX,DETY) IN circle(-2200,-1110,18200))' filtertype=expression withfilteredset=yes keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-3oc-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-3oc-oot.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes  ignoreoutoffov=no
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='((PI in [600:1300])||(PI in [1650:7200]))&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='((PI in [600:1300])||(PI in [1650:7200]))&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PI in [600:1300])&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PI in [1650:7200])&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='(PI in [600:1300])&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='(PI in [1650:7200])&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz withfilteredset=yes withspectrumset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' spectrumset=pnS003-3ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-3ff.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes withspectrumset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' spectrumset=pnS003-3ff-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-3ff-oot.pi badpixlocation=pnS003-clean-oot.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&((FLAG & 0x762a097c)==0)&&!((DETX,DETY) IN circle(-2200,-1110,18200))&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-3fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-3fc.pi withbadpixcorr=yes  badpixlocation=pnS003-clean.fits ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&((FLAG & 0x762a097c)==0)&&!((DETX,DETY) IN circle(-2200,-1110,18200))&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-3fc-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-3fc-oot.pi withbadpixcorr=yes  badpixlocation=pnS003-clean.fits ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [500:10000])&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-im3-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
farith pnS003-im3-500-10000.fits 'pnS003-mask-im-det-500-10000.fits[MASK]' pnS003-im3-500-10000-mask.fits MUL copyprime=yes 
   
mv pnS003-im3-500-10000-mask.fits pnS003-im3-500-10000.fits
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [500:10000])&&((DETX,DETY) in BOX(5840.0,-9311.0,8040.0,8216.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-im3-500-10000-oot.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
farith pnS003-im3-500-10000-oot.fits 'pnS003-mask-im-det-500-10000.fits[MASK]' pnS003-im3-500-10000-mask-oot.fits MUL copyprime=yes 
   
mv pnS003-im3-500-10000-mask-oot.fits pnS003-im3-500-10000-oot.fits
   
evselect table=pnS003-clean.fits:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0)) &&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=pnS003-4obj.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479
   
backscale spectrumset=pnS003-4obj.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes 
   
evselect table=pnS003-clean-oot.fits:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0)) &&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)&&((DETX,DETY) IN circle(-2200,-1110,17980))' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=pnS003-4obj-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479
   
backscale spectrumset=pnS003-4obj-oot.pi badpixlocation=pnS003-clean-oot.fits withbadpixcorr=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN <= 4)&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&!((DETX,DETY) IN circle(-2200,-1110,18200))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-4oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-4oc.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=pnS003-corn-oot.fits:EVENTS expression='(PATTERN <= 4)&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&!((DETX,DETY) IN circle(-2200,-1110,18200))' filtertype=expression withfilteredset=yes keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-4oc-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-4oc-oot.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes  ignoreoutoffov=no
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='((PI in [600:1300])||(PI in [1650:7200]))&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='((PI in [600:1300])||(PI in [1650:7200]))&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PI in [600:1300])&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn.fits:EVENTS withfilteredset=yes expression='(PI in [1650:7200])&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='(PI in [600:1300])&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=pnS003-corn-oot.fits:EVENTS withfilteredset=yes expression='(PI in [1650:7200])&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz withfilteredset=yes withspectrumset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' spectrumset=pnS003-4ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-4ff.pi badpixlocation=pnS003-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes withspectrumset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&((DETX,DETY) IN circle(-2200,-1110,17980))&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' spectrumset=pnS003-4ff-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-4ff-oot.pi badpixlocation=pnS003-clean-oot.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&((FLAG & 0x762a097c)==0)&&!((DETX,DETY) IN circle(-2200,-1110,18200))&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-4fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-4fc.pi withbadpixcorr=yes  badpixlocation=pnS003-clean.fits ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&((FLAG & 0x762a097c)==0)&&!((DETX,DETY) IN circle(-2200,-1110,18200))&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0))&&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=pnS003-4fc-oot.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=20479 
   
backscale spectrumset=pnS003-4fc-oot.pi withbadpixcorr=yes  badpixlocation=pnS003-clean.fits ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-filt.fits.gz:EVENTS withfilteredset=yes  expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [500:10000])&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-im4-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
farith pnS003-im4-500-10000.fits 'pnS003-mask-im-det-500-10000.fits[MASK]' pnS003-im4-500-10000-mask.fits MUL copyprime=yes 
   
mv pnS003-im4-500-10000-mask.fits pnS003-im4-500-10000.fits
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/pn-fwc-oot-filt.fits.gz withfilteredset=yes expression='(PATTERN <= 4)&&(FLAG == 0)&&(PI in [500:10000])&&((DETX,DETY) in BOX(-10241.5,-9311.0,8041.5,8216.0,0)) &&((DETX,DETY) in BOX(-2196,-1110,16060,15510,0))&&region(pnS003-bkg_region-det.fits)&&region(box_table_pn_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=pnS003-im4-500-10000-oot.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
farith pnS003-im4-500-10000-oot.fits 'pnS003-mask-im-det-500-10000.fits[MASK]' pnS003-im4-500-10000-mask-oot.fits MUL copyprime=yes 
   
mv pnS003-im4-500-10000-mask-oot.fits pnS003-im4-500-10000-oot.fits
   
rm -f filtered.fits detmap.ds
   
esky2det datastyle=user ra=266.934583333333 dec=-28.4361944444444 outunit=det withheader=no calinfostyle=set calinfoset=pnS003-obj-im-500-10000.fits verbosity=0
   
pn_back prefix=S003 caldb=$CALDB diag=0 elow=500 ehigh=10000 quad1=1 quad2=1 quad3=1 quad4=1 clobber=1
rot-im-det-sky prefix=S003 mask=1 elow=500 ehigh=10000 mode=1 clobber=1

