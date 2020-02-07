function out=align_matrix(X,Y)

n=size(X,2);
X=X-mean(X,1);
Y=Y-mean(Y,1);
[A,phi,C] = svd(X'*Y);


T=C*A';  %optimal rotation
s=trace(X'*Y*T)/trace(Y'*Y);  %optimal dilatation
M=s*Y*T;

t=(n^-1)*(X-M)'; %optimal translation
out=M+t';
