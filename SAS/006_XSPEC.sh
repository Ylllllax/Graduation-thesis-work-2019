# 复制粘贴使用

#准备工作
heaini

#begin！
xspec

cpd /xs
data PN_spectrum_grp.fits
query yes
setplot energy

notice **-**
ignore bad
ignore 0.0-0.3
ignore 10.0-**
setplot rebin 50 20
plot ldata

mod pha(po+bb)  # 回车跳过确定参数或手动输入初值

fit 100

plot ldata ratio

#用eeuf作图，存数据
plot eeuf
iplot

wdata data/energy.txt
plot
quit
