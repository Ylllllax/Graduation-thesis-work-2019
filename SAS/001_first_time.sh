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

#提取lc图像检查背景flare
evselect table=$events withrateset=Y rateset=rateEPIC.fits \
maketimecolumn=Y timebinsize=100 makeratecolumn=Y \
expression='#XMMEA_EP && (PI>10000&&PI<12000) && (PATTERN==0)'

fv rateEPIC.fits
