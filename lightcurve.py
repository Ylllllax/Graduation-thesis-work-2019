#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 13 16:40:51 2019

@author: hsz
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

data = pd.read_csv("0.3_10_tb10.csv")  

dt=10
counts = data['RATE']
N=len(counts)
pnum = np.arange(len(counts))
t = [i*dt for i in pnum]

plt.figure(figsize=(10,8))
plt.plot(t,counts,'b')
plt.xlabel("TIME(s)")
plt.ylabel("RATE(coount/s)")
plt.title("lightcurve")
plt.show()    

data_s = pd.read_csv("0.3_10_source.csv")  
data_b = pd.read_csv("0.3_10_background.csv")  

dt=100
counts_s = data_s['RATE']
N_s=len(counts_s)
pnum_s = np.arange(len(counts_s))
t_s = [i*dt for i in pnum_s]
counts_b = data_b['RATE']
N_b=len(counts_b)
pnum_b = np.arange(len(counts_b))
t_b = [i*dt for i in pnum_b]

print(t_s[-1])

plt.figure(figsize=(10,8))
plt.plot(t_s,counts_s,'b')
plt.plot(t_b,counts_b,'r')
plt.xlabel("TIME(s)")
plt.ylabel("RATE(coount/s)")
plt.title("lc of source&background")
plt.xlim(0,t_s[-1])
plt.grid()
plt.show()    