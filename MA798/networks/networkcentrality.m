
% Files taken from the SNAP collection in SuiteSparse
fname = 'as-735.mat';
mat = load(fname);

A = mat.Problem.A;
G = graph(A);
figure, spy(A)

%% degree centrality
e = ones(size(A,1),1);
d = A*e; 
[dm, id] = max(d);
fprintf('Maximum degree %f at index %g.\n', dm, id )
figure, plot(d), title('Degree centrality', 'FontSize', 18)
set(gca, 'FontSize', 16)

%% -------------------- closeness centrality
disp('Closeness centrality')

cc = centrality(G,'closeness');
[cm, im] = max(cc);
fprintf('Maximum %f at index %g.\n', cm, im )
figure, plot(cm), title('Closeness centrality', 'FontSize', 18)
set(gca, 'FontSize', 16)

%% -------------------- betweenness centrality
disp('Betweenness centrality')
cb = centrality(G,'betweenness');
[bm,ib] = max(cb);
fprintf('Maximum %f at index %g.\n', bm, im )
figure, plot(cb), title('Betweennes centrality', 'FontSize', 18)
set(gca, 'FontSize', 16)

%% --------------------eigenvector centrality
disp('Eigenvector centrality')
ce = centrality(G,'eigenvector');
[em,ie] = max(ce);
fprintf('Maximum %f at index %g.\n', em, ie )
figure, plot(ce), title('Eigenvector centrality', 'FontSize', 18)
set(gca, 'FontSize', 16)


%% Katz centrality
Anrm = normest(A);
alpha = 0.5/(Anrm + 1);
n = size(A,1);
[ck,flag,relres,iter] = pcg(speye(n) - alpha*A , e, 1.e-6, 512);
assert(~flag)
fprintf('Number of PCG iterations %g. \n', iter);
[km,ik] = max(ck);
fprintf('Maximum %f at index %g.\n', km, ik )
figure, plot(ck), title('Katz centrality', 'FontSize', 18)
set(gca, 'FontSize', 16)