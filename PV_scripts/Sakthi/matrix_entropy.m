function [Out,H]=matrix_entropy(X)
%%   [Out,Bits]=matrix_entropy(C{1, 1} ); 
%Shannon information entropy





dim=size(X,2);
a=X(X>0);
zero_P=(numel(X)-length(a))/numel(X);

[~,d,xmesh,~]=kde(a,256,0,max(a));

d=(1-zero_P)*(d./sum(d));
d(1)=zero_P;
Pm=interp1(xmesh,d,X);

Bit_matrix=log2(1./Pm);


for i=1:size(X,1)
    R(i,:)=datasample(Bit_matrix(1,:),10000,'Replace',true);
end
R=sort(sum(R,1));
thr=R(10000*0.95);

P=sum(Bit_matrix,1);

H=sum(P(P>thr))./dim;

k=logical(P>thr);
Out=X(:,k);