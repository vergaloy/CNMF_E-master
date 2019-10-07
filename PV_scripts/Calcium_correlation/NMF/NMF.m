function [W,H,E]=NMF(X,k)


% Find intial W H
 
opt = statset('Maxiter',10,'TolFun', 1e-4,'TolX',1e-4);    
[W0,H0,~] = nnmf(X,k,'replicates',100,'options',opt); 

%Get optimal results
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);
[W,H,E] = nnmf(X,k,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');

