#!/bin/bash

heaini
sasini

export SAS_CCF=ccf.cif
odf=$(echo $(ls *SUM.SAS))
export SAS_ODF=$odf

#提取所选源区域内的光子
evselect table=EPICclean.fits withfilteredset=yes filteredset=pn_filtered_annulus.evt \
      keepfilteroutput=yes expression="((X,Y) in ANNULUS(27981.1, 25623.6,160,800)) && gti(EPICgti.fits,TIME)"

#查看预期及实测事件模式分布
epatplot set=pn_filtered_annulus.evt plotfile="pn_filtered_annulus_pat.ps"

#用得到的annulus范围替换原来的circle
