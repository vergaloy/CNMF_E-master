function [X1,X2]=stabilize_matrix(X1,X2);
n1=size(X1,2);
n2=size(X2,2);
T=[X1,X2];
T=T-min(T,[],2);
T=T./max(T,[],2);
X1=[T(:,1:n1)];
X2=[T(:,n1+1:n1+n2)];