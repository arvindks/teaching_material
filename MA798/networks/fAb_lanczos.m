function [xm,relres,varargout] = fAb_lanczos(A,b,f,maxiter,tol,varargin)
%
%
% This function computes f(A)b using Lanczos approach

%
% Inputs:
%   A (n x n) - Sparse matrix or funMat type
%   b (n x 1) - right hand side
%   maxiter   - maximum number of Lanczos iterations
%         tol - tolerance for stopping
%    varargin - test {'True', 'False'} Optional parameter to verify accuracy of Lanczos relationships



if nargin > 5
  test = varargin{1};
else
  test = 'False';
end

n = size(b,1);
nrmb = norm(b);

G = speye(n);

if nargout > 3
  xhist = zeros(n,maxiter);
end

%Initialize Lanczos quantities
V = zeros(n,maxiter);
T = zeros(maxiter+1,maxiter+1);

%First step
vj = b/nrmb;
vjm1 = b*0;
beta = 0;
relres = zeros(maxiter,1);
xp = 0*b;
for j = 1:maxiter
  V(:,j) = vj;
  wj = G*(A*(G'*vj));
  alpha = wj'*vj;
  wj = wj - alpha*vj -beta*vjm1;
  beta = norm(wj);
  
  %Set vectors for new iterations
  vjm1 = vj;
  vj =    wj/beta;
  
%   %Reorthogonalize vj (CGS2) % Change to something more sophisticated
%   vj = vj - V(:,1:j)*(V(:,1:j)'*vj);  vj = vj/norm(vj);
%   vj = vj - V(:,1:j)*(V(:,1:j)'*vj);  vj = vj/norm(vj);
%   
  %Set the tridiagonal matrix
  T(j,j) = alpha;
  T(j+1,j) = beta; T(j,j+1) = beta;
  
  
  %Compute partial Lanczos solution
  Tk = T(1:j,1:j);    Vk = V(:,1:j);
  e1 = zeros(j,1);  e1(1) = nrmb;
  
  [U,D] = eig(Tk);
  xm = (Vk*U)*f(D)*((U'*e1));
  
  
  
  if nargout > 3
    xhist(:,j) = xm;
  end
  
  %Check differences b/w successive iterations
  relres(j) = norm(xm-xp)/norm(xm);
  if  relres(j) < tol
    relres = relres(1:j);
    if nargout > 3
      xhist  = xhist(:,1:j);
      varargout{1} = xhist;
    end
    break
  else
    xp = xm;
    
  end
  
end

if nargout > 3
  varargout{1} = xhist;
end

%Test the accuracy of Lanczos
if strcmp(test,'True')
  
  maxiter = size(relres,1);
  AG = 0*Vk;
  for i = 1:maxiter
    AG(:,i) = A*(G'*Vk(:,i));
  end
  AVk = G*AG;
  
  figure, imagesc(log10(abs(Vk'*AVk -Tk))), colorbar
  norm(Vk'*AVk -Tk)
  norm(Vk'*Vk- eye(maxiter))
  ek = zeros(maxiter,1);  ek(end) = beta;
  norm(AVk - Vk*Tk - vj*ek')
end
end