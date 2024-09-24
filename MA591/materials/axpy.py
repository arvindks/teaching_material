import numpy as np

"""
This file computes 
    r = a * x + y

in three different ways.

"""


@profile
def axpy(a, x, y):
    
    r = a*x + y
    return r

@profile
def axpy_wasteful(a, x, y):
    
    r = np.array([0.0])
    for i in range(x.size):
        ri = np.array([a*x[i] + y[i]])
        r = np.concatenate((r, ri)) 
    
    return r

@profile
def axpy2(a, x, y):
    
    r = np.zeros_like(x)
    for i in range(x.size):
        r[i] = a*x[i] + y[i]
    
    return r
    

    
if __name__ == '__main__':
    x = np.random.randn(10**5)
    y = np.random.randn(10**5)
    
    #Method 1: Numpy
    z = axpy(-1., x, y)
    
    #Method 1: Numpy but consumes more memory
    z = axpy_wasteful(-1., x, y)
    
    #Method 2: for loops
    z = axpy2(-1., x, y)
    