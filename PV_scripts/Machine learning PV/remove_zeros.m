function [data,active]=remove_zeros(data,len)
X=data;
n=size(X,2)-1;
parfor i=1:size(X,1)
   ct=X(i,:);
   temp=CXCORR(ct,ct);
C(i,:)=temp(2:n+1);
end
P0=mean(C(:,50:end),2);
active=1-P0;
active=active.^len;
active=active<0.05;
data=data(active,:);
end