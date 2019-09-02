function [W,H,D]=NMFC(X,Sparsity)

N=size(X,1)*size(X,2);
% Find intial W H

for order=1:size(X,1)*0.9  
opt = statset('Maxiter',100,'TolFun', 1e-8,'TolX',1e-8);    
[~,H0,R0] = nnmf(X,order,'replicates',100,'options',opt);
k=size(H0,2)*size(H0,1); 
AICc(order)=N*log(R0)/2+k+k*(k+1)/(N-k-1);  %compute Akaike's Information Criterion              
end   
[~,K]=min(AICc);  % Find optimal number of patterns

 [ W,D,H,~] =nnmf_sca(X,K,'diag','both',Sparsity,'random',1000,10);

 T=W;
 T(T>0)=1;
 T=sum(T);
 W(:,T<2)=[];
 H(T<2,:)=[];
figure;
for i=1:size(H,1)
m=ceil(size(H,1)/2);
n=2;
subplot(m,n,i);
imagesc(W(:,i)*H(i,:))
colormap('hot')
end


figure;
stackedplot(H')