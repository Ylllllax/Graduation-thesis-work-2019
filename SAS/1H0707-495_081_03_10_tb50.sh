#!/bin/bash

heaini
sasini

export SAS_CCF=ccf.cif
odf=$(echo $(ls *SUM.SAS))
export SAS_ODF=$odf

#源
evselect table=EPICclean.fits energycolumn=PI \
expression='#XMMEA_EP && (PATTERN<=4) && ((X,Y) IN annulus(27981.1, 25623.6, 160, 800)) &&(PI in [300:10000])' \
withrateset=yes rateset="PN_source_raw_03_10_tb50.lc" timebinsize=50 \
maketimecolumn=yes makeratecolumn=yes 

#背景
evselect table=EPICclean.fits \
energycolumn=PI \
expression='#XMMEA_EP && (PATTERN<=4) && ((X,Y) IN circle(36680,17320,1000))&&(PI in [300:10000])' \
withrateset=yes rateset="PN_background_raw_03_10_tb50.lc" timebinsize=50 \
maketimecolumn=yes makeratecolumn=yes 


epiclccorr srctslist=PN_source_raw_03_10_tb50.lc eventlist=EPICclean.fits outset=PN_lccorr_03_10_tb50.lc \
bkgtslist=PN_background_raw_03_10_tb50.lc withbkgset=yes applyabsolutecorrections=yes 

fv PN_lccorr_03_10_tb50.lc
