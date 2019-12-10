
function distance=PVD(X1,X2,dim)

%rng('default') % For reproducibility
%X1 = transpose(mvnrnd([3;7;5],[2 0.7 0.3;0.7 2 0.7;0.3 0.7 2],1000)); %create random multivariate data;
%X2 = transpose(mvnrnd([0;0;5],[2 0.7 0.3;0.7 2 0.7;0.3 0.7 2],1000)); %create random multivariate data;

X1(isnan(X1))=0;
X2(isnan(X2))=0;
X1(isinf(X1))=0;
X2(isinf(X2))=0;
%calcualte the mean difference between of X1 and X2;
M1=mean(X1,2)';
M2=mean(X2,2)';




%Calculate the covariance matrix of the union of X1 and X2
U = union(X1',X2','rows');
S=cov(U); 

%Calculate eigen values and eigen vectors of the covariance matrix
[V,D] = eig(S); 
   

dX=(M2-M1)';
D=sum(D);
V=((V'*dX)').^2;

[~,I]=sort(D,'descend');
D=D(I);
V=V(I);
D=D(1:dim);
V=V(1:dim);
%calcualte distance
distance=sqrt(sum(V./D));
sqrt(dX'*S^-1*dX)

%figure
%scatter3(X1(:,1),X1(:,2),X1(:,3))
%hold on
%scatter3(X2(:,1),X2(:,2),X2(:,3))








