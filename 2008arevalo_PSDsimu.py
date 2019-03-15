#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 12 14:03:19 2019

@author: hsz
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.fftpack import fft,ifft
import pandas as pd

'''
#fft说明
yy=fft(f)           #快速傅里叶变换
yreal = yy.real     # 获取实数部分
yimag = yy.imag     # 获取虚数部分
'''

#光变曲线

data = pd.read_csv("06_0.2_10.csv")  

dt=100
counts = data['RATE']

N=len(counts)
N_randomlc=len(counts)
dt=100
omega = []
POW = []
DFT = []
fr = []
fi = []
f1 = []
f2 = []
p = []
f = []

f_b=1.7E-4
alpha_H=3.8
alpha_L=1.0
for j in range(1,int(N_randomlc)+1):
    omega.append(j/(N_randomlc*dt))
    POW.append(((omega[-1]**(-alpha_L))/(1+(omega[-1]/f_b)**(alpha_H-alpha_L)))*0.005)
    DFT.append(complex(np.sqrt(POW[-1]),np.sqrt(POW[-1])))
    s1=np.random.normal(loc=0.0, scale=1.0, size=None)
    s2=np.random.normal(loc=0.0, scale=1.0, size=None)
    fr.append((DFT[-1].real)*s1)
    fi.append((DFT[-1].imag)*s2)
    f1.append(complex(fr[-1],fi[-1]))


counts = ifft(f1)
pnum = np.arange(len(counts))
t = [i*dt for i in pnum]


plt.figure(figsize=(10,8))
plt.plot(t,counts,'b')
plt.xlabel("time")
plt.ylabel("counts")
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
p_times_f = np.multiply(np.array(F),np.array(per))

POW1=POW[0:int(nf)]
P_TIMES_F = np.multiply(np.array(F),np.array(POW1))


plt.figure(figsize=(10,8))
plt.loglog(F,P_TIMES_F,color="b",linewidth=1)
plt.loglog(F1,p_times_f,color="r",linewidth=1)    
plt.xlabel("frequency")
plt.ylabel("power*frequency")
plt.title("power density spectrum")
plt.show()

