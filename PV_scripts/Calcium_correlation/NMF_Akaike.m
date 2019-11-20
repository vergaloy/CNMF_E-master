function [W,H,D]=NMF_Akaike(X)

max_order=size(X,1)/2;
N=size(X,1)*size(X,2);
for order=1:max_order 
opt = statset('Maxiter',100,'TolFun', 1e-4,'TolX',1e-4);    
[W0,H0,~] = nnmf(X,order,'replicates',100,'options',opt,'algorithm','mult');
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);
[W,H,D] = nnmf(X,order,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');
             
RSS=sqrt(sum((X-W*H).^2,'all'));
k=size(X,1)*order+size(X,2)*order; % sum(S)+
AICc(order)=N*log(RSS/N)+2*k+(2*k*(k+1))/(N-k-1); %  %compute Akaike's Information Criterion              
%BIC=N*log(D0)+k*log(N);
end  

[~,K]=min(AICc);  % Find optimal number of patterns
[W0,H0,~] = nnmf(X,K,'replicates',1000);

%Get optimal results
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);
[W,H,D] = nnmf(X,K,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');

W=W./max(W,[],1);
W(W<0.2)=0;
t=W;
t(t>0)=1;
t=sum(t,1);
t(t<5)=0;
t(t>0)=1;
W(:,~logical(t))=[]; 
H(~logical(t),:)=[];             
