function Y=align_matrix(X,Y)

n=size(X,1);
X=X-sum(X,1);
Y=Y-sum(Y,1);
[A,phi,C] = svd(X'*Y);
C=C';

T=C*A';
s=trace(X'*Y*T)/trace(Y'*Y);
t=(n^-1)*(X-s*Y*T)';

Y=s*Y*T+1*t';