function [W,H]=NMF_corr(X,W0)


opt = statset('Maxiter',1000,'Display','final','TolFun', 1e-1,'TolX',1e-1);
[W,H,~] = nnmf(X,size(W0,2),'w0',W0,'options',opt,'algorithm','als');

