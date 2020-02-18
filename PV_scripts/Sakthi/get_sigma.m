function get_sigma(X)

[n,d]=size(X);
gam=ceil(n^(1/2));


del=0.1/n^(d/(d+4));
perm=randperm(n);
mu=X(perm(1:gam),:);
w=rand(1,gam);
w=w/sum(w);
Sig=bsxfun(@times,rand(d,d,gam),eye(d)*del);
ent=-Inf;
for iter=1:1500 % begin algorithm
    Eold=ent;
    [w,mu,Sig,del,ent]=regEM(w,mu,Sig,del,X); % update parameters
    err=abs((ent-Eold)/ent); % stopping condition
    fprintf('Iter.    Tol.      Bandwidth \n');
    fprintf('%4i    %8.2e   %8.2e\n',iter,err,del);
    fprintf('----------------------------\n');
    if (err<10^-4)|(iter>1000), break, end
end
end

function [w,mu,Sig,del,ent]=regEM(w,mu,Sig,del,X)
[gam,d]=size(mu);[n,d]=size(X);
log_lh=zeros(n,gam); log_sig=log_lh; 
for i=1:gam
    L=chol(Sig(:,:,i));
    Xcentered = bsxfun(@minus, X, mu(i,:));
    xRinv = Xcentered /L; xSig = sum((xRinv /L').^2,2)+eps;
    log_lh(:,i)=-.5*sum(xRinv.^2, 2)-sum(log(diag(L)))...
        +log(w(i))-d*log(2*pi)/2-.5*del^2*trace((eye(d)/L)/L');
    log_sig(:,i)=log_lh(:,i)+log(xSig);
end
maxll = max (log_lh,[],2); maxlsig = max (log_sig,[],2);
p= exp(bsxfun(@minus, log_lh, maxll));
psig=exp(bsxfun(@minus, log_sig, maxlsig));
density = sum(p,2);  psigd=sum(psig,2);
logpdf=log(density)+maxll; logpsigd=log(psigd)+maxlsig;
p = bsxfun(@rdivide, p, density);
ent=sum(logpdf); w=sum(p,1);
for i=find(w>0)
    mu(i,:)=p(:,i)'*X/w(i);  %compute mu's
    Xcentered = bsxfun(@minus, X,mu(i,:));
    Xcentered = bsxfun(@times,sqrt(p(:,i)),Xcentered);
    Sig(:,:,i)=Xcentered'*Xcentered/w(i)+del^2*eye(d); % compute sigmas;
end
w=w/sum(w);curv=mean(exp(logpsigd-logpdf)); % estimate curvature
del=1/(4*n*(4*pi)^(d/2)*curv)^(1/(d+2));
end