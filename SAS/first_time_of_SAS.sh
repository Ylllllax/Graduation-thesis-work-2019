#!/bin/bash

heaini
sasini

export SAS_ODF=$PWD
cifbuild

export SAS_CCF=ccf.cif
odfingest

odf=$(echo $(ls *SUM.SAS))
#也可以使用 a=$(echo $(ls | grep *SUM.SAS)) 即用管道命令，从所有显示字符中抽取带有*SUM.SAS的字符传送到a中

export SAS_ODF=$odf

#生成事件列表
epproc

events=$(echo $(ls *vts*))

#处理背景flare
evselect table=$events withrateset=Y rateset=rateEPIC.fits \
maketimecolumn=Y timebinsize=100 makeratecolumn=Y \
expression='#XMMEA_EP && (PI>10000&&PI<12000) && (PATTERN==0)'

tabgtigen table=rateEPIC.fits expression='RATE<=0.4' gtiset=EPICgti.fits

evselect table=$events withfilteredset=Y filteredset=EPICclean.fits \
destruct=Y keepfilteroutput=T \
expression='#XMMEA_EP && gti(EPICgti.fits,TIME) && (PI>150)'

#将原始事件复制保留，用barycen修正事件
cp EPICclean.fits PN_evt_nobarycen_cor.fits
barycen table=EPICclean.fits:EVENTS

#提取图像
evselect table=EPICclean.fits imagebinning=binSize imageset=PNimage.img withimageset=yes \
xcolumn=X ycolumn=Y ximagebinsize=80 yimagebinsize=80

imgdisplay withimagefile=true imagefile=PNimage.img
