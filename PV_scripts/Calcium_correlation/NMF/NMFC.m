function [W,H]=NMFC(X)

N=size(X,1)*size(X,2);
% Find intial W H

for order=1:8  
opt = statset('Maxiter',100,'TolFun', 1e-4,'TolX',1e-4);    
[~,~,D0] = nnmf(X,order,'replicates',100,'options',opt);
k=order*(size(X,1)+size(X,2)); 
AICc(order)=N*log(D0)+2*k+(2*k*(k+1))/(N-k-1);  %compute Akaike's Information Criterion  
if order>1   
    if AICc(order)>AICc(order-1)
        break
    end
end

end   

[~,K]=min(AICc);  % Find optimal number of patterns
[W0,H0,~] = nnmf(X,K,'replicates',100,'options',opt);

%Get optimal results
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);
[W,H,~] = nnmf(X,K,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');