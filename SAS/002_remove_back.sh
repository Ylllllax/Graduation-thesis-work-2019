#!/bin/bash

heaini
sasini

export SAS_CCF=ccf.cif
odf=$(echo $(ls *SUM.SAS))
export SAS_ODF=$odf

#根据lc情况（合理设定RATE阈值）处理背景flare
tabgtigen table=rateEPIC.fits expression='RATE<=0.7' gtiset=EPICgti.fits

evselect table=$events withfilteredset=Y filteredset=EPICclean.fits \
destruct=Y keepfilteroutput=T \
expression='#XMMEA_EP && gti(EPICgti.fits,TIME) && (PI>150)'

#将原始事件复制保留，用barycen修正事件
cp EPICclean.fits PN_evt_nobarycen_cor.fits
barycen table=EPICclean.fits:EVENTS

#提取图像，确定源及背景区域
evselect table=EPICclean.fits imagebinning=binSize imageset=PNimage.img withimageset=yes \
xcolumn=X ycolumn=Y ximagebinsize=80 yimagebinsize=80

ds9 PNimage.img
