#!/bin/bash

heaini
sasini

export SAS_CCF=ccf.cif
odf=$(echo $(ls *SUM.SAS))
export SAS_ODF=$odf

#源
evselect table=EPICclean.fits energycolumn=PI \
expression='#XMMEA_EP && (PATTERN<=4) && ((X,Y) IN circle(27770.5, 26940.5,1000)) &&(PI in [300:10000])' \
withrateset=yes rateset="PN_source_lightcurve_raw.lc" timebinsize=100 \
maketimecolumn=yes makeratecolumn=yes 

#背景
evselect table=EPICclean.fits \
energycolumn=PI \
expression='#XMMEA_EP && (PATTERN<=4) && ((X,Y) IN circle(27640.5,22580.5,1000))&&(PI in [300:10000])' \
withrateset=yes rateset="PN_light_curve_background_raw.lc" timebinsize=100 \
maketimecolumn=yes makeratecolumn=yes 


epiclccorr srctslist=PN_source_lightcurve_raw.lc eventlist=EPICclean.fits outset=PN_lccorr.lc \
bkgtslist=PN_light_curve_background_raw.lc withbkgset=yes applyabsolutecorrections=yes 

fv PN_lccorr.lc
