function [Out,H,D,E]=NMF_Akaike(X)

[X,E]=matrix_entropy(X);



k1=sum(X,2);
k1(k1>0)=1;
X(logical(1-k1),:)=[];


max_order=min([size(X,1),size(X,2)])-1;
N=size(X,1)*size(X,2);

for r=1:max_order 
[W0,H0,~] = nnmf(X,r,'replicates',100,'algorithm','mult');
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);
[W,H,~] = nnmf(X,r,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');

H(max(W,[],1)==0,:)=[];             
W(:,max(W,[],1)==0)=[];  
order=size(W,2);             
             
RSS=sqrt(sum((X-W*H).^2,'all'));
k=size(X,1)*order+size(X,2)*order; % sum(S)+
AICc(order)=N*log(RSS/N)+2*k+(2*k*(k+1))/(N-k-1); %  %compute Akaike's Information Criterion              
end  

[~,K]=nanmin(AICc);  % Find optimal number of patterns

[W0,H0,~] = nnmf(X,K,'replicates',1000);

%Get optimal results
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);
[W,H,D] = nnmf(X,K,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');
A=max(W,[],1);             
W=W./A; 
H=H./A';

W(W<0.05)=0;
T=W;
T(T>0)=1;
T=sum(T,1);
T=(T<3);
W(:,T)=[];
H(T,:)=[];

             
Out(1:length(k1),1:size(W,2))=0;

Out(logical(k1),:)=W;

