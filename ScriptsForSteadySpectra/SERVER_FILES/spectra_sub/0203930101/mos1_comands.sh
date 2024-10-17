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




evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(PI in [500:8000])' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-obj-im.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400 yimagemin=3401 updateexposure=yes filterexposure=yes verbosity=1


atthkgen atthkset=atthk.fits timestep=1 
eexpmap attitudeset=atthk.fits eventset=mos1S001-clean.fits:EVENTS expimageset=mos1S001-exp-im.fits imageset=mos1S001-obj-im.fits pimax=10000 pimin=300 withdetcoords=no 
emask detmaskset=mos1S001-mask-im.fits expimageset=mos1S001-exp-im.fits threshold1=0.01 threshold2=5.0 






#MOS1
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-obj-im-sp-det.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes filtertype=expression expression='(PATTERN<=12)&&(FLAG == 0) &&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-obj-im-det-500-10000.fits squarepixels=yes ignorelegallimits=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes
   
eexpmap attitudeset=atthk.fits eventset=mos1S001-clean.fits:EVENTS expimageset=mos1S001-exp-im.fits imageset=mos1S001-obj-im.fits pimax=8000 pimin=300 withdetcoords=no
   
emask detmaskset=mos1S001-mask-im.fits expimageset=mos1S001-exp-im.fits threshold1=0.01 threshold2=0.5
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos1S001-obj.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-obj.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes filtertype=expression expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=detmap.ds squarepixels=yes ignorelegallimits=no withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=120 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=120 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes
   
rmfgen format=var rmfset=mos1S001.rmf spectrumset=mos1S001-obj.pi threshold=1.0e-6 detmaptype=dataset detmaparray=detmap.ds
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes filtertype=expression expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' imagebinning='imageSize' imagedatatype='Int32' imageset=detmap.ds squarepixels=yes ignorelegallimits=no withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=120 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=120 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes
   
arfgen arfset=mos1S001.arf spectrumset=mos1S001-obj.pi withrmfset=yes rmfset=mos1S001.rmf extendedsource=yes modelee=no withbadpixcorr=no detmaptype=dataset detmaparray=detmap.ds  badpixlocation=mos1S001-clean.fits modelootcorr=no
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0) &&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7))&&region(mos1S001-bkg_region-sky.fits)&&region(box_table_m1_sky.fits)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))'  filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-obj-im-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='X' ximagesize=900 ximagemax=48400 ximagemin=3401 ycolumn='Y' yimagesize=900 yimagemax=48400 yimagemin=3401 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
eexpmap attitudeset=atthk.fits eventset=mos1S001-clean.fits:EVENTS expimageset=mos1S001-exp-im-500-10000.fits imageset=mos1S001-obj-im-500-10000.fits pimax=10000 pimin=500 withdetcoords=no
   
emask detmaskset=mos1S001-mask-im-500-10000.fits expimageset=mos1S001-exp-im-500-10000.fits threshold1=0.1 threshold2=0.5
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&((DETX,DETY) in BOX(20,-60,6610,6570,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))' withspectrumset=yes spectrumset=mos1S001-1ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-1ff.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(20,-60,6610,6570,0))&&(PATTERN<=12)&&(FLAG == 0) &&((CCDNR == 1)||(CCDNR == 2)||(CCDNR == 3)||(CCDNR == 4)||(CCDNR == 5)||(CCDNR == 6)||(CCDNR == 7))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))'  filtertype=expression imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-obj-im-500-10000-ccd1.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
eexpmap attitudeset=atthk.fits eventset=mos1S001-clean.fits:EVENTS expimageset=mos1S001-exp-im-500-10000-ccd1.fits imageset=mos1S001-obj-im-500-10000-ccd1.fits pimax=10000 pimin=500 withdetcoords=yes
   
emask detmaskset=mos1S001-mask-im-500-10000-ccd1.fits expimageset=mos1S001-exp-im-500-10000-ccd1.fits threshold1=0.01 threshold2=0.5
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN <= 12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&((DETX,DETY) in BOX(20,-60,6610,6570,0))&&(PI in [500:10000])' imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-im1-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500 yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
farith mos1S001-im1-500-10000.fits 'mos1S001-mask-im-500-10000-ccd1.fits[MASK]' mos1S001-im1-500-10000-mask.fits MUL copyprime=yes 
   
mv mos1S001-im1-500-10000-mask.fits mos1S001-im1-500-10000.fits 
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(20,-60,6610,6570,0))&&(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos1S001-1obj.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-1obj.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(6550,-13572,6590,6599,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-2oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-2oc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(6550,-13572,6590,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos1S001-2obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-2obj.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(6550,-13572,6590,6599,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(6550,-13572,6590,6599,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(6550,-13572,6590,6599,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) in BOX(6550,-13572,6590,6599,0))&&!(((DETX,DETY) in CIRCLE(100,-200,17700))||((DETX,DETY) in CIRCLE(834,135,17100))||((DETX,DETY) in CIRCLE(770,-803,17100))||((DETX,DETY) in BOX(-20,-17000,6500,500,0))||((DETX,DETY) in BOX(5880,-20500,7500,1500,10))||((DETX,DETY) in BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) in BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-2fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-2fc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(6550,-13572,6590,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos1S001-2ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-2ff.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(6550,-13572,6590,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-im2-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(13280,-306,6610,6599,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-3oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-3oc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(13280,-306,6610,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos1S001-3obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-3obj.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(13280,-306,6610,6599,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(13280,-306,6610,6599,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(13280,-306,6610,6599,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) in BOX(13280,-306,6610,6599,0))&&!(((DETX,DETY) in CIRCLE(100,-200,17700))||((DETX,DETY) in CIRCLE(834,135,17100))||((DETX,DETY) in CIRCLE(770,-803,17100))||((DETX,DETY) in BOX(-20,-17000,6500,500,0))||((DETX,DETY) in BOX(5880,-20500,7500,1500,10))||((DETX,DETY) in BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) in BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-3fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-3fc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(13280,-306,6610,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos1S001-3ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-3ff.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(13280,-306,6610,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-im3-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(6700,13070,6530,6560,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-4oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-4oc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(6700,13070,6530,6560,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos1S001-4obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-4obj.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(6700,13070,6530,6560,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(6700,13070,6530,6560,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(6700,13070,6530,6560,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) in BOX(6700,13070,6530,6560,0))&&!(((DETX,DETY) in CIRCLE(100,-200,17700))||((DETX,DETY) in CIRCLE(834,135,17100))||((DETX,DETY) in CIRCLE(770,-803,17100))||((DETX,DETY) in BOX(-20,-17000,6500,500,0))||((DETX,DETY) in BOX(5880,-20500,7500,1500,10))||((DETX,DETY) in BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) in BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-4fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-4fc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(6700,13070,6530,6560,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos1S001-4ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-4ff.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(6700,13070,6530,6560,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-im4-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(-6410,13130,6570,6560,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-5oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-5oc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(-6410,13130,6570,6560,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos1S001-5obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-5obj.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(-6410,13130,6570,6560,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(-6410,13130,6570,6560,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(-6410,13130,6570,6560,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) in BOX(-6410,13130,6570,6560,0))&&!(((DETX,DETY) in CIRCLE(100,-200,17700))||((DETX,DETY) in CIRCLE(834,135,17100))||((DETX,DETY) in CIRCLE(770,-803,17100))||((DETX,DETY) in BOX(-20,-17000,6500,500,0))||((DETX,DETY) in BOX(5880,-20500,7500,1500,10))||((DETX,DETY) in BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) in BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-5fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-5fc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(-6410,13130,6570,6560,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos1S001-5ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-5ff.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(-6410,13130,6570,6560,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-im5-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(-13169,-105,6599,6599,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-6oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-6oc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(-13169,-105,6599,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos1S001-6obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-6obj.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(-13169,-105,6599,6599,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(-13169,-105,6599,6599,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(-13169,-105,6599,6599,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) in BOX(-13169,-105,6599,6599,0))&&!(((DETX,DETY) in CIRCLE(100,-200,17700))||((DETX,DETY) in CIRCLE(834,135,17100))||((DETX,DETY) in CIRCLE(770,-803,17100))||((DETX,DETY) in BOX(-20,-17000,6500,500,0))||((DETX,DETY) in BOX(5880,-20500,7500,1500,10))||((DETX,DETY) in BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) in BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-6fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-6fc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(-13169,-105,6599,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos1S001-6ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-6ff.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(-13169,-105,6599,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-im6-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(-6540,-13438,6570,6599,0))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-7oc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-7oc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no
   
evselect table=mos1S001-clean.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(-6540,-13438,6570,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' filtertype=expression keepfilteroutput=no updateexposure=yes filterexposure=yes withspectrumset=yes spectrumset=mos1S001-7obj.pi energycolumn=PI  spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999
   
backscale spectrumset=mos1S001-7obj.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(-6540,-13438,6570,6599,0))&&(PI in [300:10000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(-6540,-13438,6570,6599,0))&&(PI in [500:800])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=mos1S001-corn.fits:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&((FLAG & 0x766a0f63)==0)&&((DETX,DETY) in BOX(-6540,-13438,6570,6599,0))&&(PI in [2500:5000])' filtertype=expression filteredset=temp_events.fits keepfilteroutput=yes updateexposure=yes filterexposure=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(PATTERN<=12)&&(FLAG == 65536)&&((DETX,DETY) in BOX(-6540,-13438,6570,6599,0))&&!(((DETX,DETY) in CIRCLE(100,-200,17700))||((DETX,DETY) in CIRCLE(834,135,17100))||((DETX,DETY) in CIRCLE(770,-803,17100))||((DETX,DETY) in BOX(-20,-17000,6500,500,0))||((DETX,DETY) in BOX(5880,-20500,7500,1500,10))||((DETX,DETY) in BOX(-5920,-20500,7500,1500,350))||((DETX,DETY) in BOX(-20,-20000,5500,500,0)))' filtertype=expression keepfilteroutput=no withspectrumset=yes spectrumset=mos1S001-7fc.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-7fc.pi useodfatt=no badpixlocation=mos1S001-clean.fits withbadpixcorr=yes ignoreoutoffov=no 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='(FLAG == 0)&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))&&((DETX,DETY) in BOX(-6540,-13438,6570,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)' withspectrumset=yes keepfilteroutput=no updateexposure=yes filterexposure=yes spectrumset=mos1S001-7ff.pi energycolumn=PI spectralbinsize=5 withspecranges=yes specchannelmin=0 specchannelmax=11999 
   
backscale spectrumset=mos1S001-7ff.pi badpixlocation=mos1S001-clean.fits withbadpixcorr=yes 
   
evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(-6540,-13438,6570,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-im7-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
#evselect table=/user/home/dehiwald/workdir/sasfiles/caldb/caldb_esas/mos1-fwc.fits.gz:EVENTS withfilteredset=yes expression='((DETX,DETY) in BOX(-6540,-13438,6570,6599,0))&&region(mos1S001-bkg_region-det.fits)&&region(box_table_m1_det.fits)&&(FLAG == 0)&&(PI in [500:10000])&&(((DETX,DETY) IN box(-2683.5,-15917,2780.5,1340,0))||((DETX,DETY) IN box(2743.5,-16051,2579.5,1340,0))||((DETX,DETY) IN circle(97,-172,17152)))' imagebinning='imageSize' imagedatatype='Int32' imageset=mos1S001-im7-500-10000.fits squarepixels=yes withxranges=yes withyranges=yes xcolumn='DETX' ximagesize=780 ximagemax=19500 ximagemin=-19499 ycolumn='DETY' yimagesize=780 yimagemax=19500  yimagemin=-19499 updateexposure=yes filterexposure=yes ignorelegallimits=yes 
   
#esky2det datastyle=user ra=266.934583333333 dec=-28.4361944444444 outunit=det withheader=no calinfostyle=set calinfoset=mos1S001-obj-im-500-10000.fits verbosity=0   
#rot_det_sky mode=1 prefix=1S001 elow=500 ehigh=10000 detx=-1410.514105 dety=-1393.213932 skyx=450.91 skyy=450.91 maskfile=0 clobber=1
mos_back prefix=1S001 caldb=$CALDB  diag=0 elow=500 ehigh=10000 ccd1=1 ccd2=1 ccd3=1 ccd4=1 ccd5=1 ccd6=1 ccd7=1 clobber=1
rot-im-det-sky prefix=1S001 mask=1 elow=500 ehigh=10000 mode=1 clobber=1
  




