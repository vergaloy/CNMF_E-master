function [W,H,E]=NMF(X,k)


% Find intial W H
 
opt = statset('Maxiter',10,'TolFun', 1e-4,'TolX',1e-4);    
[W0,H0,~] = nnmf(X,k,'replicates',100,'options',opt); 

%Get optimal results
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);
[W,H,E] = nnmf(X,k,'w0',W0,'h0',H0,...
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
%D=W*H;
%H2=H*((W'*D)/(W'*W*H));

 

