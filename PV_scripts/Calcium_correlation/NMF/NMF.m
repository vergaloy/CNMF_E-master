function [W,H]=NMF(X)

N=size(X,1)*size(X,2);
% Find intial W H

for order=1:size(X,1)*0.5  
opt = statset('Maxiter',100,'TolFun', 1e-4,'TolX',1e-4);    
[~,H0,D0] = nnmf(X,order,'replicates',100,'options',opt);
k=order*(size(H0,2)+size(H0,1)); 
AICc(order)=N*log(D0)+2*k+(2*k*(k+1))/(N-k-1);            %N*log(D0)/2+k+k*(k+1)/(N-k-1);  %compute Akaike's Information Criterion              
end  
[~,K]=min(AICc);  % Find optimal number of patterns
[W0,H0,~] = nnmf(X,K,'replicates',1000);

%Get optimal results
opt = statset('Maxiter',1000,'Display','final','TolFun', 1e-8,'TolX',1e-8);
[W,H,~] = nnmf(X,K,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');

