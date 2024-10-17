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






evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(PI in [500:8000])' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-obj-im.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400 yimagemin=3401 updateexposure=yes filterexposure=yes verbosity=1
 


atthkgen atthkset=atthk.fits timestep=1 
eexpmap attitudeset=atthk.fits eventset=mos2S002-clean.fits:EVENTS expimageset=mos2S002-exp-im.fits imageset=mos2S002-obj-im.fits pimax=10000 pimin=300 withdetcoords=no 
emask detmaskset=mos2S002-mask-im.fits expimageset=mos2S002-exp-im.fits threshold1=0.01 threshold2=5.0 



#MOS2 ops
 

evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(PI in [500:8000])' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-obj-im.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400 yimagemin=3401 updateexposure=yes filterexposure=yes verbosity=1
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-obj-im-sp-det.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes filtertype=expression expression='(PATTERN<=12)&&(FLAG == 0) &&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-obj-im-det-500-10000.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes
   
eexpmap attitudeset=atthk.fits eventset=mos2S002-clean.fits:EVENTS expimageset=mos2S002-exp-im.fits imageset=mos2S002-obj-im.fits pimax=8000 pimin=300 withdetcoords=no
   
emask detmaskset=mos2S002-mask-im.fits expimageset=mos2S002-exp-im.fits threshold1=0.01 threshold2=0.5
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos2S002-obj.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999  > row_count_m2.log
   
backscale spectrumset=mos2S002-obj.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes filtertype=expression expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=detmap.ds squarepixels=yes ignorelegallimits=no withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=120 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=120 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes
   
rmfgen format=var rmfset=mos2S002.rmf spectrumset=mos2S002-obj.pi threshold=1.0e-6 detmaptype=dataset detmaparray=detmap.ds
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes filtertype=expression expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=detmap.ds squarepixels=yes ignorelegallimits=no withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=120 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=120 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes
   
arfgen arfset=mos2S002.arf spectrumset=mos2S002-obj.pi withrmfset=yes rmfset=mos2S002.rmf extendedsource=yes modelee=no withbadpixcorr=no detmaptype=dataset detmaparray=detmap.ds  badpixlocation=mos2S002-clean.fits modelootcorr=no
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0) &&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7))&&region(mos2S002-bkg_region-sky.fits)&&region(box_table_m2_sky.fits)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))'  filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-obj-im-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400 yimagemin=3401 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
eexpmap attitudeset=atthk.fits eventset=mos2S002-clean.fits:EVENTS expimageset=mos2S002-exp-im-500-10000.fits imageset=mos2S002-obj-im-500-10000.fits pimax=10000 pimin=500 withdetcoords=no
   
emask detmaskset=mos2S002-mask-im-500-10000.fits expimageset=mos2S002-exp-im-500-10000.fits threshold1=0.1 threshold2=0.5
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&((DETX,DETY) IN BOX(20,-60,6610,6590,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))' withspectrumset=yes spectrumset=mos2S002-1ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-1ff.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(20,-60,6610,6590,0))&&(PATTERN<=12)&&(FLAG == 0) &&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))'  filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-obj-im-500-10000-ccd1.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
eexpmap attitudeset=atthk.fits eventset=mos2S002-clean.fits:EVENTS expimageset=mos2S002-exp-im-500-10000-ccd1.fits imageset=mos2S002-obj-im-500-10000-ccd1.fits pimax=10000 pimin=500 withdetcoords=yes
   
emask detmaskset=mos2S002-mask-im-500-10000-ccd1.fits expimageset=mos2S002-exp-im-500-10000-ccd1.fits threshold1=0.01 threshold2=0.5
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN <= 12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&((DETX,DETY) IN BOX(20,-60,6610,6590,0))&&(PI in [500:10000])' imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-im1-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
farith mos2S002-im1-500-10000.fits 'mos2S002-mask-im-500-10000-ccd1.fits[MASK]' mos2S002-im1-500-10000-mask.fits MUL copyprime=yes 
   
mv mos2S002-im1-500-10000-mask.fits mos2S002-im1-500-10000.fits 
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(20,-60,6610,6590,0))&&(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos2S002-1obj.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-1obj.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(6580,-13530,6620,6640,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-2oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-2oc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(6580,-13530,6620,6640,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos2S002-2obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-2obj.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(6580,-13530,6620,6640,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(6580,-13530,6620,6640,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(6580,-13530,6620,6640,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) IN BOX(6580,-13530,6620,6640,0))&&!(((DETX,DETY) IN CIRCLE(435,1006,17100))||((DETX,DETY) IN CIRCLE(-34,68,17700))||((DETX,DETY) IN BOX(-20,-17000,6500,500,0))||((DETX,DETY) IN BOX(5880,-20500,7500,1500,10))||((DETX,DETY) IN BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) IN BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-2fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-2fc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(6580,-13530,6620,6640,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos2S002-2ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-2ff.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(6580,-13530,6620,6640,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-im2-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(13320,-295,6620,6590,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-3oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-3oc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(13320,-295,6620,6590,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos2S002-3obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-3obj.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(13320,-295,6620,6590,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(13320,-295,6620,6590,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(13320,-295,6620,6590,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) IN BOX(13320,-295,6620,6590,0))&&!(((DETX,DETY) IN CIRCLE(435,1006,17100))||((DETX,DETY) IN CIRCLE(-34,68,17700))||((DETX,DETY) IN BOX(-20,-17000,6500,500,0))||((DETX,DETY) IN BOX(5880,-20500,7500,1500,10))||((DETX,DETY) IN BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) IN BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-3fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-3fc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(13320,-295,6620,6590,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos2S002-3ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-3ff.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(13320,-295,6620,6590,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-im3-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(6610,13110,6590,6550,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-4oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-4oc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(6610,13110,6590,6550,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos2S002-4obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-4obj.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(6610,13110,6590,6550,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(6610,13110,6590,6550,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(6610,13110,6590,6550,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) IN BOX(6610,13110,6590,6550,0))&&!(((DETX,DETY) IN CIRCLE(435,1006,17100))||((DETX,DETY) IN CIRCLE(-34,68,17700))||((DETX,DETY) IN BOX(-20,-17000,6500,500,0))||((DETX,DETY) IN BOX(5880,-20500,7500,1500,10))||((DETX,DETY) IN BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) IN BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-4fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-4fc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(6610,13110,6590,6550,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos2S002-4ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-4ff.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(6610,13110,6590,6550,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-im4-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(-6560,13180,6590,6600,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-5oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-5oc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(-6560,13180,6590,6600,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos2S002-5obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-5obj.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(-6560,13180,6590,6600,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(-6560,13180,6590,6600,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(-6560,13180,6590,6600,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) IN BOX(-6560,13180,6590,6600,0))&&!(((DETX,DETY) IN CIRCLE(435,1006,17100))||((DETX,DETY) IN CIRCLE(-34,68,17700))||((DETX,DETY) IN BOX(-20,-17000,6500,500,0))||((DETX,DETY) IN BOX(5880,-20500,7500,1500,10))||((DETX,DETY) IN BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) IN BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-5fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-5fc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(-6560,13180,6590,6600,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos2S002-5ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-5ff.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(-6560,13180,6590,6600,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-im5-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(-13190,-90,6600,6630,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-6oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-6oc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(-13190,-90,6600,6630,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos2S002-6obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-6obj.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(-13190,-90,6600,6630,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(-13190,-90,6600,6630,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(-13190,-90,6600,6630,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) IN BOX(-13190,-90,6600,6630,0))&&!(((DETX,DETY) IN CIRCLE(435,1006,17100))||((DETX,DETY) IN CIRCLE(-34,68,17700))||((DETX,DETY) IN BOX(-20,-17000,6500,500,0))||((DETX,DETY) IN BOX(5880,-20500,7500,1500,10))||((DETX,DETY) IN BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) IN BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-6fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-6fc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(-13190,-90,6600,6630,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos2S002-6ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-6ff.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(-13190,-90,6600,6630,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-im6-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(-6620,-13438,6620,6599,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-7oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-7oc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos2S002-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(-6620,-13438,6620,6599,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos2S002-7obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos2S002-7obj.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(-6620,-13438,6620,6599,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(-6620,-13438,6620,6599,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos2S002-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) IN BOX(-6620,-13438,6620,6599,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) IN BOX(-6620,-13438,6620,6599,0))&&!(((DETX,DETY) IN CIRCLE(435,1006,17100))||((DETX,DETY) IN CIRCLE(-34,68,17700))||((DETX,DETY) IN BOX(-20,-17000,6500,500,0))||((DETX,DETY) IN BOX(5880,-20500,7500,1500,10))||((DETX,DETY) IN BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) IN BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos2S002-7fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-7fc.pi useodfatt=no badpixlocation=mos2S002-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))&&((DETX,DETY) IN BOX(-6620,-13438,6620,6599,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos2S002-7ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos2S002-7ff.pi badpixlocation=mos2S002-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(-6620,-13438,6620,6599,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-im7-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos2-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) IN BOX(-6620,-13438,6620,6599,0))&&region(mos2S002-bkg_region-det.fits)&&region(box_table_m2_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN circle(-61,-228,17085))||((DETX,DETY) IN box(14.375,-16567.6,5552.62,795.625,0)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos2S002-im7-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
esky2det datastyle=user ra=266.934583333333 dec=-28.4361944444444 outunit=det withheader=no calinfostyle=set calinfoset=mos2S002-obj-im-500-10000.fits verbosity=0

mos_back prefix=2S002 caldb=$CALDB  diag=0 elow=500 ehigh=10000 ccd1=1 ccd2=1 ccd3=1 ccd4=1 ccd5=1 ccd6=1 ccd7=1  
rot-im-det-sky prefix=2S002 mask=1 elow=500 ehigh=10000 mode=1



   
