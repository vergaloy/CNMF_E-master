function [W,H]=NMF_minimize(X)


N=size(X,1)*size(X,2);

if (size(X,1)*0.5<size(X,2)*0.5)
    max_order=size(X,1)*0.5;
else
    max_order=size(X,2)*0.5;
end    

for order=1:max_order 
opt = statset('Maxiter',100,'TolFun', 1e-4,'TolX',1e-4);    
[W0,H0,~] = nnmf(X,1,'replicates',100,'options',opt,'algorithm','mult');

end  