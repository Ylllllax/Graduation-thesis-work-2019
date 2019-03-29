#!/bin/bash

heaini
sasini

export SAS_CCF=ccf.cif
odf=$(echo $(ls *SUM.SAS))
export SAS_ODF=$odf

#源
evselect table=EPICclean.fits energycolumn=PI \
expression='#XMMEA_EP && (PATTERN<=4) && ((X,Y) IN annulus(24160, 24750, 150, 1000)) &&(PI in [300:10000])' \
withrateset=yes rateset="PN_source_lightcurve_raw.lc" timebinsize=10 \
maketimecolumn=yes makeratecolumn=yes 

#背景
evselect table=EPICclean.fits \
energycolumn=PI \
expression='#XMMEA_EP && (PATTERN<=4) && ((X,Y) IN circle(42440,30600,1500))&&(PI in [300:10000])' \
withrateset=yes rateset="PN_light_curve_background_raw.lc" timebinsize=10 \
maketimecolumn=yes makeratecolumn=yes 


epiclccorr srctslist=PN_source_lightcurve_raw.lc eventlist=EPICclean.fits outset=PN_lccorr.lc \
bkgtslist=PN_light_curve_background_raw.lc withbkgset=yes applyabsolutecorrections=yes 

fv PN_lccorr.lc
