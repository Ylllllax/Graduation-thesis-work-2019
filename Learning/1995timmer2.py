#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 28 20:19:03 2019

@author: hsz
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.fftpack import fft,ifft


'''
#fft说明
yy=fft(f)           #快速傅里叶变换
yreal = yy.real     # 获取实数部分
yimag = yy.imag     # 获取虚数部分
'''

#光变曲线

beta = 2.0   #用于检验的beta值为 1.0 or 2.0
N = 1024
dt=1
omega = []
POW = []
DFT = []
fr = []
fi = []
f1 = []
f2 = []
counts = []
p = []
f = []

for j in range(1,int(N)+1):
    omega.append(j/(N*dt))
    POW.append((1/omega[-1])**beta)
    DFT.append(complex(np.sqrt(POW[-1]),np.sqrt(POW[-1])))
    s1=np.random.normal(loc=0.0, scale=1.0, size=None)
    s2=np.random.normal(loc=0.0, scale=1.0, size=None)
    fr.append((DFT[-1].real)*s1)
    fi.append((DFT[-1].imag)*s2)
    f1.append(complex(fr[-1],fi[-1]))


'''   
a=512
for j in range(1,int(N)//2+1):
    a=a-1
    f2.append(complex(fr[a],-fi[a]))


f0=[0]
f.extend(f2)
f.extend(f0)
f.extend(f1)
'''

counts = ifft(f1)
t = np.arange(len(counts))

plt.figure(figsize=(10,8))
plt.plot(t,counts,'b')
plt.xlabel("time")
plt.ylabel("counts")
plt.xlim(0,1024)
plt.title("lightcurve")
plt.show()    



#周期图

nf = N/2
df = 1/(dt*N)
F_a = np.arange(1,nf+1)
F = [i*df for i in F_a]
F1 = F[0:int(nf)]
mean_x = np.mean(counts)
x_new  = [i-mean_x for i in counts]
dft   = fft(x_new)
dft_1 = dft[1:int(nf)+1]
per = (abs(dft_1)**2)

POW1=POW[0:int(nf)]

x1=np.log(F)+np.log(1024)
y1=np.log(POW1)
x2=np.log(F1)+np.log(1024)
y2=np.log(per)

plt.figure(figsize=(10,8))
plt.plot(x1,y1,color="b",linewidth=1)
plt.plot(x2,y2,color="r",linewidth=1)    
plt.xlabel("log frequency")
plt.ylabel("log power")
plt.xlim(0,np.log(512))
plt.title("power density spectrum")
plt.show()
