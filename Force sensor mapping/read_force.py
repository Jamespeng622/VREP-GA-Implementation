#!/usr/bin/env python
# coding: utf-8

# In[45]:


import numpy as np
import matplotlib.pyplot as plt
fig = plt.gcf()
fig.set_size_inches(20,15)
force1, force2, force3, force4 = np.loadtxt("C:/Users/Administrator/Desktop/test_force_output.txt", delimiter=",").transpose()
plt.plot(force1, linestyle='--', marker='o', label='Force1')
plt.plot(force2, linestyle='--', marker='o', label='Force2')
plt.plot(force3, linestyle='--', marker='o', label='Force3')
plt.plot(force4, linestyle='--', marker='o', label='Force4')
plt.title('Force Mapping', fontsize=20)
plt.ylabel('Force', fontsize=15)
plt.xlabel('unit timestep', fontsize=15)
plt.legend(fontsize=20)
plt.grid()
plt.show()


# In[ ]:




