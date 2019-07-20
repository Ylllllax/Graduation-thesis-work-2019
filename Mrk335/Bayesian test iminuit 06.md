

```python
import numpy as np
import math
import matplotlib.pyplot as plt
from scipy.fftpack import fft,ifft
import pandas as pd
from scipy.optimize import minimize
from scipy.optimize import basinhopping
from iminuit import Minuit

import emcee
from pprint import pprint
import time
from multiprocessing import Pool
```

bending power-law 模型

↓

↓

↓


```python
# 似然函数 p; D = -2 ln p

def twi_minus_loglikelihood(log_A,log_f_b,alpha_H,poisson):
    alpha_L = 1.0
    
    perdata06 = pd.read_csv("perlist06.csv")
    f = perdata06['f']
    per = perdata06['per']
            
    model = []
    f_length = len(f)
    for i in range(f_length):
        model.append(((f[i]**(-alpha_L))/(1+(f[i]/(10**log_f_b))**(alpha_H-alpha_L)))*(10**log_A)+poisson)
     
    
    length = len(perdata06)
    minus_log_p = 0
    for i in range(length):
        minus_log_p += (per[i]/model[i]+math.log(model[i]))
    
    
    D = 2*minus_log_p
    # print (D)
    return D
```


```python
m=Minuit(twi_minus_loglikelihood,log_A=math.log(0.005,10),log_f_b=math.log(1.7E-4,10),alpha_H=3.8,poisson=0.8,
         error_log_A=0.1,error_log_f_b=0.1,error_alpha_H=0.01,error_poisson=0.01,
         limit_log_A=(-3,-2), limit_log_f_b=(-4,-3),limit_alpha_H=(2.0,5.0),limit_poisson=(0,1),
         errordef=1)

m.migrad()

print(m.fval)
m.print_param()
```


<hr>



<table>
    <tr>
        <td title="Minimum value of function">FCN = -1913.0851229698399</td>
        <td title="Total number of call to FCN so far">TOTAL NCALL = 195</td>
        <td title="Number of call in last migrad">NCALLS = 195</td>
    </tr>
    <tr>
        <td title="Estimated distance to minimum">EDM = 8.590644620979727e-06</td>
        <td title="Maximum EDM definition of convergence">GOAL EDM = 1e-05</td>
        <td title="Error def. Amount of increase in FCN to be defined as 1 standard deviation">
        UP = 1.0</td>
    </tr>
</table>
<table>
    <tr>
        <td align="center" title="Validity of the migrad call">Valid</td>
        <td align="center" title="Validity of parameters">Valid Param</td>
        <td align="center" title="Is Covariance matrix accurate?">Accurate Covar</td>
        <td align="center" title="Positive definiteness of covariance matrix">PosDef</td>
        <td align="center" title="Was covariance matrix made posdef by adding diagonal element">Made PosDef</td>
    </tr>
    <tr>
        <td align="center" style="background-color:#92CCA6">True</td>
        <td align="center" style="background-color:#92CCA6">True</td>
        <td align="center" style="background-color:#92CCA6">True</td>
        <td align="center" style="background-color:#92CCA6">True</td>
        <td align="center" style="background-color:#92CCA6">False</td>
    </tr>
    <tr>
        <td align="center" title="Was last hesse call fail?">Hesse Fail</td>
        <td align="center" title="Validity of covariance">HasCov</td>
        <td align="center" title="Is EDM above goal EDM?">Above EDM</td>
        <td align="center"></td>
        <td align="center" title="Did last migrad call reach max call limit?">Reach calllim</td>
    </tr>
    <tr>
        <td align="center" style="background-color:#92CCA6">False</td>
        <td align="center" style="background-color:#92CCA6">True</td>
        <td align="center" style="background-color:#92CCA6">False</td>
        <td align="center"></td>
        <td align="center" style="background-color:#92CCA6">False</td>
    </tr>
</table>



<table>
    <tr>
        <td><a href="#" onclick="$('#pksvMEVrbE').toggle()">+</a></td>
        <td title="Variable name">Name</td>
        <td title="Value of parameter">Value</td>
        <td title="Hesse error">Hesse Error</td>
        <td title="Minos lower error">Minos Error-</td>
        <td title="Minos upper error">Minos Error+</td>
        <td title="Lower limit of the parameter">Limit-</td>
        <td title="Upper limit of the parameter">Limit+</td>
        <td title="Is the parameter fixed in the fit">Fixed?</td>
    </tr>
    <tr>
        <td>0</td>
        <td>log_A</td>
        <td>-2.32574</td>
        <td>0.134782</td>
        <td></td>
        <td></td>
        <td>-3</td>
        <td>-2</td>
        <td>No</td>
    </tr>
    <tr>
        <td>1</td>
        <td>log_f_b</td>
        <td>-3.76866</td>
        <td>0.105849</td>
        <td></td>
        <td></td>
        <td>-4</td>
        <td>-3</td>
        <td>No</td>
    </tr>
    <tr>
        <td>2</td>
        <td>alpha_H</td>
        <td>3.62322</td>
        <td>0.354755</td>
        <td></td>
        <td></td>
        <td>2</td>
        <td>5</td>
        <td>No</td>
    </tr>
    <tr>
        <td>3</td>
        <td>poisson</td>
        <td>0.119922</td>
        <td>0.00393606</td>
        <td></td>
        <td></td>
        <td>0</td>
        <td>1</td>
        <td>No</td>
    </tr>
</table>
<pre id="pksvMEVrbE" style="display:none;">
<textarea rows="14" cols="50" onclick="this.select()" readonly>
\begin{tabular}{|c|r|r|r|r|r|r|r|c|}
\hline
 & Name & Value & Hesse Error & Minos Error- & Minos Error+ & Limit- & Limit+ & Fixed?\\
\hline
0 & $log_{A}$ & -2.32574 & 0.134782 &  &  & -3.0 & -2 & No\\
\hline
1 & log $f_{b}$ & -3.76866 & 0.105849 &  &  & -4.0 & -3 & No\\
\hline
2 & $\alpha_{H}$ & 3.62322 & 0.354755 &  &  & 2.0 & 5 & No\\
\hline
3 & poisson & 0.119922 & 0.00393606 &  &  & 0.0 & 1 & No\\
\hline
\end{tabular}
</textarea>
</pre>



<hr>


    -1913.0851229698399
    


<table>
    <tr>
        <td><a href="#" onclick="$('#bhwFrhhYjk').toggle()">+</a></td>
        <td title="Variable name">Name</td>
        <td title="Value of parameter">Value</td>
        <td title="Hesse error">Hesse Error</td>
        <td title="Minos lower error">Minos Error-</td>
        <td title="Minos upper error">Minos Error+</td>
        <td title="Lower limit of the parameter">Limit-</td>
        <td title="Upper limit of the parameter">Limit+</td>
        <td title="Is the parameter fixed in the fit">Fixed?</td>
    </tr>
    <tr>
        <td>0</td>
        <td>log_A</td>
        <td>-2.32574</td>
        <td>0.134782</td>
        <td></td>
        <td></td>
        <td>-3</td>
        <td>-2</td>
        <td>No</td>
    </tr>
    <tr>
        <td>1</td>
        <td>log_f_b</td>
        <td>-3.76866</td>
        <td>0.105849</td>
        <td></td>
        <td></td>
        <td>-4</td>
        <td>-3</td>
        <td>No</td>
    </tr>
    <tr>
        <td>2</td>
        <td>alpha_H</td>
        <td>3.62322</td>
        <td>0.354755</td>
        <td></td>
        <td></td>
        <td>2</td>
        <td>5</td>
        <td>No</td>
    </tr>
    <tr>
        <td>3</td>
        <td>poisson</td>
        <td>0.119922</td>
        <td>0.00393606</td>
        <td></td>
        <td></td>
        <td>0</td>
        <td>1</td>
        <td>No</td>
    </tr>
</table>
<pre id="bhwFrhhYjk" style="display:none;">
<textarea rows="14" cols="50" onclick="this.select()" readonly>
\begin{tabular}{|c|r|r|r|r|r|r|r|c|}
\hline
 & Name & Value & Hesse Error & Minos Error- & Minos Error+ & Limit- & Limit+ & Fixed?\\
\hline
0 & $log_{A}$ & -2.32574 & 0.134782 &  &  & -3.0 & -2 & No\\
\hline
1 & log $f_{b}$ & -3.76866 & 0.105849 &  &  & -4.0 & -3 & No\\
\hline
2 & $\alpha_{H}$ & 3.62322 & 0.354755 &  &  & 2.0 & 5 & No\\
\hline
3 & poisson & 0.119922 & 0.00393606 &  &  & 0.0 & 1 & No\\
\hline
\end{tabular}
</textarea>
</pre>



```python
perdata06 = pd.read_csv("perlist06.csv")
f = perdata06['f']
per = perdata06['per']

alpha_L = 1.0
log_A,log_f_b,alpha_H,poisson = m.values[0],m.values[1],m.values[2],m.values[3]

model = []
R = []
T_SSE = 0
f_length = len(f)
for i in range(f_length):
    model.append(((f[i]**(-alpha_L))/(1+(f[i]/(10**log_f_b))**(alpha_H-alpha_L)))*(10**log_A)+poisson)
    R.append(2*per[i]/model[i])
    T_SSE += (((per[i]-model[i])/model[i])**2)
    
plt.figure(figsize=(10,8))
plt.loglog()
plt.step(f, per, color="b", alpha=0.5, linewidth=1)
plt.plot(f, model, color="r", linewidth=1)
plt.xlabel("frequency",fontsize=15)
plt.ylabel("power",fontsize=15)
plt.show()
```


![png](output_4_0.png)



```python
T_R = max(R)
print ("T_R=", T_R)
print ("T_SSE=", T_SSE)
```

    T_R= 12.127666609316472
    T_SSE= 963.6468048800665
    


```python
# 均匀先验

def lnprior(theta):
    log_A,log_f_b,alpha_H,poisson = theta
    alpha_L = 1.0
    if -3 < log_A < -2 and -5 < log_f_b < -3 and 2.0 < alpha_H < 5.0 and 0.0 < poisson < 1.0:
        return 0.0
    return -np.inf

# 后验概率？

def lnprob(theta):
    log_A,log_f_b,alpha_H,poisson = theta
    lp = lnprior(theta)
    if not np.isfinite(lp):
        return -np.inf
    return (lp - 0.5* twi_minus_loglikelihood(log_A,log_f_b,alpha_H,poisson))
```


```python
# emcee

ndim, nwalkers = 4, 100
pos = [[m.values[0],m.values[1],m.values[2],m.values[3]] + 1e-4*np.random.randn(ndim) for i in range(nwalkers)]
sampler = emcee.EnsembleSampler(nwalkers, ndim, lnprob)


# 显示进度并记录时间
import sys

nsteps = 500
width = 30
start = time.time()
for i, result in enumerate(sampler.sample(pos, iterations=nsteps)):
    z = int((width+1) * float(i) / nsteps)
    sys.stdout.write("\r[{0}{1}]".format('#' * z, ' ' * (width - z)))
sys.stdout.write("\n")
end = time.time()
multi_time = end - start
print("Serial took {0:.1f} seconds".format(multi_time))
```

    [##############################]
    Serial took 1596.9 seconds
    


```python
'''
tau = sampler.get_autocorr_time()
print(tau)

# The chain is too short to reliably estimate the autocorrelation time
'''
```




    '\ntau = sampler.get_autocorr_time()\nprint(tau)\n\n# The chain is too short to reliably estimate the autocorrelation time\n'




```python
fig, axes = plt.subplots(4, figsize=(10, 7), sharex=True)
samples = sampler.chain
labels = ["log_A", "log_f_b", "alpha_H","poisson"]
for i in range(ndim):
    ax = axes[i]
    ax.plot(np.transpose(samples[:,:,i]), "k", alpha=0.3)
    ax.set_xlim(0, len(samples[1]))
    ax.set_ylabel(labels[i])
    ax.yaxis.set_label_coords(-0.1, 0.5)

axes[-1].set_xlabel("step number");
```


![png](output_9_0.png)



```python
samples = sampler.chain[:, 100:, :].reshape((-1, ndim))

labels = ["log A", "log f_b", "alpha_H","poisson"]

from IPython.display import display, Math

for i in range(ndim):
    mcmc = np.percentile(samples[:, i], [16, 50, 84])
    q = np.diff(mcmc)
    txt = "\mathrm{{{3}}} = {0:.5f}_{{-{1:.5f}}} ^{{+{2:.5f}}}"
    txt = txt.format(mcmc[1], q[0], q[1], labels[i])
    display(Math(txt))
```


$$\mathrm{log A} = -2.32756_{-0.12682} ^{+0.14145}$$



$$\mathrm{log f_b} = -3.76248_{-0.11344} ^{+0.09859}$$



$$\mathrm{alpha_H} = 3.66115_{-0.34251} ^{+0.39135}$$



$$\mathrm{poisson} = 0.12000_{-0.00372} ^{+0.00421}$$



```python
import corner
fig = corner.corner(samples, labels=["$log A$", "$log f_b$", "$alpha_H$", "$poisson$"],
                      truths=[m.values[0], m.values[1], m.values[2], m.values[3]])
```


![png](output_11_0.png)



```python






```

nobreak power-law 模型

↓

↓

↓


```python
def twi_minus_loglikelihood_nobreak(log_A,alpha,poisson):
    alpha_L = 1.0
    
    perdata091 = pd.read_csv("perlist06.csv")
    f = perdata091['f']
    per = perdata091['per']
            
    model = []
    f_length = len(f)
    for i in range(f_length):
        model.append((f[i]**(-alpha))*(10**log_A)+poisson)
     
    
    length = len(perdata091)
    minus_log_p = 0
    for i in range(length):
        minus_log_p += (per[i]/model[i]+math.log(model[i]))
    
    
    D = 2*minus_log_p
    # print (D)
    return D
```


```python
n=Minuit(twi_minus_loglikelihood_nobreak,log_A=-9,alpha=2.0,poisson=1.0,
         error_log_A=0.1,error_alpha=0.01,error_poisson=0.01,
         limit_log_A=(-11,-8),limit_alpha=(1.0,5.0),limit_poisson=(0,2),
         errordef=1)

n.migrad()

print(n.fval)
n.print_param()
```


<hr>



<table>
    <tr>
        <td title="Minimum value of function">FCN = -1889.6670913657365</td>
        <td title="Total number of call to FCN so far">TOTAL NCALL = 130</td>
        <td title="Number of call in last migrad">NCALLS = 130</td>
    </tr>
    <tr>
        <td title="Estimated distance to minimum">EDM = 2.8656924130776533e-05</td>
        <td title="Maximum EDM definition of convergence">GOAL EDM = 1e-05</td>
        <td title="Error def. Amount of increase in FCN to be defined as 1 standard deviation">
        UP = 1.0</td>
    </tr>
</table>
<table>
    <tr>
        <td align="center" title="Validity of the migrad call">Valid</td>
        <td align="center" title="Validity of parameters">Valid Param</td>
        <td align="center" title="Is Covariance matrix accurate?">Accurate Covar</td>
        <td align="center" title="Positive definiteness of covariance matrix">PosDef</td>
        <td align="center" title="Was covariance matrix made posdef by adding diagonal element">Made PosDef</td>
    </tr>
    <tr>
        <td align="center" style="background-color:#92CCA6">True</td>
        <td align="center" style="background-color:#92CCA6">True</td>
        <td align="center" style="background-color:#92CCA6">True</td>
        <td align="center" style="background-color:#92CCA6">True</td>
        <td align="center" style="background-color:#92CCA6">False</td>
    </tr>
    <tr>
        <td align="center" title="Was last hesse call fail?">Hesse Fail</td>
        <td align="center" title="Validity of covariance">HasCov</td>
        <td align="center" title="Is EDM above goal EDM?">Above EDM</td>
        <td align="center"></td>
        <td align="center" title="Did last migrad call reach max call limit?">Reach calllim</td>
    </tr>
    <tr>
        <td align="center" style="background-color:#92CCA6">False</td>
        <td align="center" style="background-color:#92CCA6">True</td>
        <td align="center" style="background-color:#92CCA6">False</td>
        <td align="center"></td>
        <td align="center" style="background-color:#92CCA6">False</td>
    </tr>
</table>



<table>
    <tr>
        <td><a href="#" onclick="$('#PzcTgORFVs').toggle()">+</a></td>
        <td title="Variable name">Name</td>
        <td title="Value of parameter">Value</td>
        <td title="Hesse error">Hesse Error</td>
        <td title="Minos lower error">Minos Error-</td>
        <td title="Minos upper error">Minos Error+</td>
        <td title="Lower limit of the parameter">Limit-</td>
        <td title="Upper limit of the parameter">Limit+</td>
        <td title="Is the parameter fixed in the fit">Fixed?</td>
    </tr>
    <tr>
        <td>0</td>
        <td>log_A</td>
        <td>-9.03486</td>
        <td>0.533156</td>
        <td></td>
        <td></td>
        <td>-11</td>
        <td>-8</td>
        <td>No</td>
    </tr>
    <tr>
        <td>1</td>
        <td>alpha</td>
        <td>2.6515</td>
        <td>0.156771</td>
        <td></td>
        <td></td>
        <td>1</td>
        <td>5</td>
        <td>No</td>
    </tr>
    <tr>
        <td>2</td>
        <td>poisson</td>
        <td>0.11705</td>
        <td>0.00398442</td>
        <td></td>
        <td></td>
        <td>0</td>
        <td>2</td>
        <td>No</td>
    </tr>
</table>
<pre id="PzcTgORFVs" style="display:none;">
<textarea rows="12" cols="50" onclick="this.select()" readonly>
\begin{tabular}{|c|r|r|r|r|r|r|r|c|}
\hline
 & Name & Value & Hesse Error & Minos Error- & Minos Error+ & Limit- & Limit+ & Fixed?\\
\hline
0 & $log_{A}$ & -9.03486 & 0.533156 &  &  & -11.0 & -8 & No\\
\hline
1 & $\alpha$ & 2.6515 & 0.156771 &  &  & 1.0 & 5 & No\\
\hline
2 & poisson & 0.11705 & 0.00398442 &  &  & 0.0 & 2 & No\\
\hline
\end{tabular}
</textarea>
</pre>



<hr>


    -1889.6670913657365
    


<table>
    <tr>
        <td><a href="#" onclick="$('#HhplxOKWPQ').toggle()">+</a></td>
        <td title="Variable name">Name</td>
        <td title="Value of parameter">Value</td>
        <td title="Hesse error">Hesse Error</td>
        <td title="Minos lower error">Minos Error-</td>
        <td title="Minos upper error">Minos Error+</td>
        <td title="Lower limit of the parameter">Limit-</td>
        <td title="Upper limit of the parameter">Limit+</td>
        <td title="Is the parameter fixed in the fit">Fixed?</td>
    </tr>
    <tr>
        <td>0</td>
        <td>log_A</td>
        <td>-9.03486</td>
        <td>0.533156</td>
        <td></td>
        <td></td>
        <td>-11</td>
        <td>-8</td>
        <td>No</td>
    </tr>
    <tr>
        <td>1</td>
        <td>alpha</td>
        <td>2.6515</td>
        <td>0.156771</td>
        <td></td>
        <td></td>
        <td>1</td>
        <td>5</td>
        <td>No</td>
    </tr>
    <tr>
        <td>2</td>
        <td>poisson</td>
        <td>0.11705</td>
        <td>0.00398442</td>
        <td></td>
        <td></td>
        <td>0</td>
        <td>2</td>
        <td>No</td>
    </tr>
</table>
<pre id="HhplxOKWPQ" style="display:none;">
<textarea rows="12" cols="50" onclick="this.select()" readonly>
\begin{tabular}{|c|r|r|r|r|r|r|r|c|}
\hline
 & Name & Value & Hesse Error & Minos Error- & Minos Error+ & Limit- & Limit+ & Fixed?\\
\hline
0 & $log_{A}$ & -9.03486 & 0.533156 &  &  & -11.0 & -8 & No\\
\hline
1 & $\alpha$ & 2.6515 & 0.156771 &  &  & 1.0 & 5 & No\\
\hline
2 & poisson & 0.11705 & 0.00398442 &  &  & 0.0 & 2 & No\\
\hline
\end{tabular}
</textarea>
</pre>



```python
log_A,alpha,poisson = n.values[0],n.values[1],n.values[2]

model2 = []
f_length = len(f)
for i in range(f_length):
    model2.append((f[i]**(-alpha))*(10**log_A)+poisson)
    
plt.figure(figsize=(10,8))
plt.loglog()
plt.step(f, per, color="b", alpha=0.5, linewidth=1)
plt.plot(f, model2, color="r", linewidth=1)
plt.xlabel("frequency",fontsize=13)
plt.ylabel("power",fontsize=13)
plt.show()
```


![png](output_16_0.png)



```python
# 对无截断幂律谱尝试emcee

# 均匀先验

def lnprior_nobreak(theta):
    log_A,alpha,poisson = theta
    if -13 < log_A < -5 and 1.0 < alpha < 4.0 and 0.0 < poisson < 2.0:
        return 0.0
    return -np.inf

# 后验概率？

def lnprob_nobreak(theta):
    log_A,alpha,poisson = theta
    lp = lnprior_nobreak(theta)
    if not np.isfinite(lp):
        return -np.inf
    return (lp - 0.5* twi_minus_loglikelihood_nobreak(log_A,alpha,poisson))
```


```python
# emcee

ndim, nwalkers = 3, 100
pos = [[n.values[0],n.values[1],n.values[2]] + 1e-4*np.random.randn(ndim) for i in range(nwalkers)]
sampler_nobreak = emcee.EnsembleSampler(nwalkers, ndim, lnprob_nobreak)


# 显示进度并记录时间
import sys

nsteps = 500
width = 30
start = time.time()
for i, result in enumerate(sampler_nobreak.sample(pos, iterations=nsteps)):
    z = int((width+1) * float(i) / nsteps)
    sys.stdout.write("\r[{0}{1}]".format('#' * z, ' ' * (width - z)))
sys.stdout.write("\n")
end = time.time()
multi_time = end - start
print("Serial took {0:.1f} seconds".format(multi_time))
```

    [##############################]
    Serial took 1146.9 seconds
    


```python
fig, axes = plt.subplots(3, figsize=(10, 7), sharex=True)
samples_nobreak = sampler_nobreak.chain
labels = ["log_A", "alpha","poisson"]
for i in range(ndim):
    ax = axes[i]
    ax.plot(np.transpose(samples_nobreak[:,:,i]), "k", alpha=0.3)
    ax.set_xlim(0, len(samples_nobreak[1]))
    ax.set_ylabel(labels[i])
    ax.yaxis.set_label_coords(-0.1, 0.5)

axes[-1].set_xlabel("step number");
```


![png](output_19_0.png)



```python
samples_nobreak = sampler_nobreak.chain[:, 100:, :].reshape((-1, ndim))
labels = ["log_A", "alpha","poisson"]

from IPython.display import display, Math

for i in range(ndim):
    mcmc = np.percentile(samples_nobreak[:, i], [16, 50, 84])
    q = np.diff(mcmc)
    txt = "\mathrm{{{3}}} = {0:.7f}_{{-{1:.7f}}}^{{+{2:.7f}}}"
    txt = txt.format(mcmc[1], q[0], q[1], labels[i])
    display(Math(txt))
```


$$\mathrm{log_A} = -9.1161183_{-0.4785637}^{0.4763207}$$



$$\mathrm{alpha} = 2.6744220_{-0.1359175}^{0.1387684}$$



$$\mathrm{poisson} = 0.1172520_{-0.0039451}^{0.0039734}$$



```python
import corner
fig = corner.corner(samples_nobreak, labels=["$logA$", "$alpha$", "$poisson$"],
                      truths=[n.values[0], n.values[1], n.values[2]])
```


![png](output_21_0.png)



```python






```

两种模型差异

↓

↓

↓


```python
# LRT statistic
T = n.fval-m.fval
print(T)
```

    23.418031604103362
    


```python
import scipy.stats as stats

p = stats.chi2.pdf(T,1)
p1 = ("%.7f" % p)
plt.figure(figsize=(10,8))
plt.plot(np.linspace(0,25,100),stats.chi2.pdf(np.linspace(0,25,100),df=1))
plt.axvline(T,color="r")
plt.text(0.7,0.8,'p=%s'%p1,color='red',ha='center',transform=ax.transAxes,fontsize=13)
plt.xlabel("LRT statistic",fontsize=13)
plt.ylabel("density",fontsize=13)
plt.show()
```


![png](output_25_0.png)



```python

```
