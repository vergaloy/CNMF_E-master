function [Out,H]=matrix_entropy(X);
%Shannon information entropy

a=X(X>0);
zero_P=(numel(X)-length(a))/numel(X);

[~,d,xmesh,~]=kde(a,256,0,max(a));

d=(1-zero_P)*(d./sum(d));
d(1)=zero_P;
Pm=interp1(xmesh,d,X);
P=prod(Pm,1);

P=-P.*log(P);
H=sum(P);
T=sort(P);
k=logical(P<T(floor(length(T)*0.05)));
Out=X(:,k);