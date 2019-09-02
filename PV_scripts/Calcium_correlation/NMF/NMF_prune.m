function [W,H]=NMF_prune(X)


N=size(X,1)*size(X,2);
% Find intial W H

F=X;
F(F<0.001)=0;
F(F==0)=nan;
st=nanmean(F,2)+nanstd(F,1,2)*3;
if (size(X,1)*0.5<size(X,2)*0.5)
    max_order=size(X,1)*0.5;
else
    max_order=size(X,2)*0.5;
end    

for order=1:max_order 
opt = statset('Maxiter',100,'TolFun', 1e-4,'TolX',1e-4);    
[W0,H0,~] = nnmf(X,order,'replicates',100,'options',opt,'algorithm','mult');
% Prune patterns             
S=W0;
S(S<st)=0;
W0=S;
S=sum(W0~=0,1);
W0(:,2>S)=[];
H0(2>S,:)=[];
numer = W0'*X;
H0 = max(0,H0 .* (numer ./ ((W0'*W0)*H0 + eps(numer))));
D0 = norm(X-W0*H0,'fro')/sqrt(N);
k=size(X,1)*order+size(X,2)*order; % sum(S)+
AICc(order)=N*log(D0)+2*k+(2*k*(k+1))/(N-k-1); %  %compute Akaike's Information Criterion              
%BIC=N*log(D0)+k*log(N);
end  

[~,K]=min(AICc);  % Find optimal number of patterns
[W0,H0,~] = nnmf(X,K,'replicates',1000);

%Get optimal results
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);
[W0,H0,~] = nnmf(X,K,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');

             
             
             
%% Prune patterns             
F=X;
F(F<0.001)=0;
F(F==0)=nan;
st=nanmean(F,2)+nanstd(F,1,2)*2;
clear F
S=W0;
S(S<st)=0;
W0=S;
S=sum(W0~=0,1);
W0(:,2>S)=[];
H0(2>S,:)=[];
numer = W0'*X;
H0 = max(0,H0 .* (numer ./ ((W0'*W0)*H0 + eps(numer))));
K=size(W0,2);
%update 
if (K==0)
    W(1:size(X,1),1)=0;
    H(1,1:size(X,2))=0;
    disp('No patterns found')
 return   
end    
[W,H,~] = nnmf(X,K,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');
             
%prune again             
             
F=X;
F(F<0.001)=0;
F(F==0)=nan;
st=nanmean(F,2)+nanstd(F,1,2)*2;
clear F
S=W;
S(S<st)=0;
W=S;
S=sum(W~=0,1);
W(:,2>S)=[];
H(2>S,:)=[];
numer = W'*X;
H = max(0,H .* (numer ./ ((W'*W)*H + eps(numer))));             
             


%figure;
%n=ceil(sqrt(size(H,1)));
%m=round(sqrt(size(H,1)));
%for i=1:size(H,1)
%subplot(m,n,i);
%imagesc(W(:,i)*H(i,:))
%colormap('hot')
%end



%figure;
%stackedplot(H')