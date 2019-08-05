#!/bin/bash

heaini
sasini

export SAS_CCF=ccf.cif
odf=$(echo $(ls *SUM.SAS))
export SAS_ODF=$odf

#提取源光谱
evselect table=EPICclean.fits \
    withspectrumset=yes spectrumset=PNsource_spectrum.fits \
    energycolumn=PI spectralbinsize=5 \
    withspecranges=yes specchannelmin=0 specchannelmax=20479 \
    expression='(FLAG==0) && (PATTERN<=4) && ((X,Y) IN annulus(27981.1, 25623.6, 160, 800))'

#提取背景光谱
evselect table=EPICclean.fits \
    withspectrumset=yes spectrumset=PNbackground_spectrum.fits \
    energycolumn=PI spectralbinsize=5 \
    withspecranges=yes specchannelmin=0 specchannelmax=20479 \
    expression='(FLAG==0) && (PATTERN<=4) && ((X,Y) IN circle(36680,17320,1000))'

#计算
backscale spectrumset=PNsource_spectrum.fits badpixlocation=EPICclean.fits
backscale spectrumset=PNbackground_spectrum.fits badpixlocation=EPICclean.fits

#生成再分配矩阵
rmfgen spectrumset=PNsource_spectrum.fits rmfset=PN.rmf

#生成辅助文件
arfgen spectrumset=PNsource_spectrum.fits arfset=PN.arf withrmfset=yes rmfset=PN.rmf \
    badpixlocation=PNclean.fits detmaptype=psf

#组合
specgroup spectrumset=PNsource_spectrum.fits mincounts=25 oversample=3 rmfset=PN.rmf \
    arfset=PN.arf backgndset=PNbackground_spectrum.fits groupedset=PN_spectrum_grp.fits
