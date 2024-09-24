import numpy as np
from tomopy.misc import phantom

__all__ = ['gravity', 'blur']

def gravity(n, example = 1, a = 0., b = 1., d = 0.25):
	"""
	A line by line translation of 1-D gravity surveying model problem
	Regularization ToolBox

	"""
	
	
	# Setup the matrix
	dt = 1./n
	ds = (b-a)/n
	t = dt*(np.arange(n) + 0.5)
	s = a + ds*(np.arange(n) + 0.5)

	T,S = np.meshgrid(t,s)

	A = dt*d*np.ones((n,n), dtype = 'd')/(d**2. + (S-T)**2.)**(3./2);

	# Setup the solution vector and the right hand side
	nt = np.round(n/3);
	nn = np.round(n*7/8);
	x = np.zeros((n,), dtype = 'd')
	if example == 0:
		x = np.sin(np.pi*t) + 0.5*np.sin(2*np.pi*t);
	elif example == 1:
		x[:nt]     = np.arange(1,nt+1)*(2/nt)
		x[nt:nn+1] =  ((2*nn-nt) - np.arange(nt+1,nn+2))/(nn-nt);
		x[nn+1:]   = (n - np.arange(nn+2,n+1))/(n-nn);
		
	elif example == 2:
		x[:nt] = np.ones((nt,), dtype = 'd')
	
	b = np.dot(A,x)

	return A, b, x


def blur(N, band = 3,sigma = 0.7, phant = 'shepp'):
	from scipy.linalg import toeplitz
	from scipy.sparse import csr_matrix, kron

    	z = np.exp(-np.arange(band)**2./(2*sigma**2.))
	z = np.hstack((z.reshape((1,-1)), np.zeros((1,N-band), dtype = 'd')))

	A = toeplitz(z)
	A = csr_matrix(A)
	A = (1./(2.*np.pi*sigma**2.))*kron(A,A)


	if phant == 'blank':
        	xtrue = 0.5 + np.zeros((N**2,), dtype = 'd')
    	elif phant == 'barbara':
        	x = phantom.barbara(N, dtype = 'd')
        	xtrue = x.squeeze().reshape((-1,))
    	elif phant == 'cameraman':
        	x = phantom.cameraman(N, dtype = 'd')
        	xtrue = x.squeeze().reshape((-1,))
    	elif phant == 'checkerboard':
        	x = phantom.checkerboard(N, dtype = 'd')
        	xtrue = x.squeeze().reshape((-1,))
    	elif phant == 'peppers':
        	x = phantom.peppers(N, dtype = 'd')
        	xtrue = x.squeeze().reshape((-1,))
    	elif phant == 'shepp':
        	x = phantom.shepp2d(N, dtype = 'd')
        	xtrue = x.squeeze().reshape((-1,))
   
	b = A.dot(xtrue)

	return A, b, xtrue

	
 
