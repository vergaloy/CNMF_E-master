function [W,H,E]=NMF(X)

N=size(X,1)*size(X,2);
% Find intial W H
 
opt = statset('Maxiter',100,'TolFun', 1e-4,'TolX',1e-4);    
[W0,H0,~] = nnmf(X,1,'replicates',1000,'options',opt); 

%Get optimal results
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);
[W,H,E] = nnmf(X,1,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');

