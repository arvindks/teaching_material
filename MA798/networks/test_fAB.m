% Files taken from the SNAP collection in SuiteSparse

myFolder = './';
myFiles = dir(fullfile(myFolder,'*.mat'));

for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fname = fullfile(myFolder, baseFileName);
    mat = load(fname);
    
    A = mat.Problem.A;
    
    Anrm = normest(A);
    alpha = 0.9/(Anrm + 1);
    
    disp('Network name: ')
    fprintf(fname)
    fprintf('\n')
    fprintf('Number of nodes %g and edges % g.\n', size(A,1), nnz(triu(A)))
    
    % Degree centrality
    n = size(A,1);
    e = ones(n,1);
    d = A*e; 
    [dm, id] = max(d);
    
    fprintf('Maximum degree %g at index %g.\n', dm, id )
    
    % Katz centrality
    [ck,flag,relres,iter] = pcg(speye(n) - alpha*A , e, 1.e-6, 512);
    assert(~flag)
    fprintf('Number of PCG iterations %g. \n', iter);
    [km,ik] = max(ck);
    fprintf('Maximum of Katz %f at index %g.\n', km, ik )
   
    
    % Total communicability
    
    [ct,relres] = fAb_lanczos(A, ones(size(A,1),1), @(x) exp(0.5*x), 100, 1.e-4);
    [tm,it] = max(ct);
    fprintf('Number of Lanczos iterations %g. \n', length(relres));
    fprintf('Maximum of Total %f at index %g.\n', tm, it);
    
    fprintf('\n\n')
    
end

