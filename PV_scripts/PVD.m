%rng('default') % For reproducibility
%X1 = mvnrnd([3;7;5],[2 0.7 0.3;0.7 2 0.7;0.3 0.7 2],1000); %create random multivariate data;
%X2 = mvnrnd([0;0;5],[2 0.7 0.3;0.7 2 0.7;0.3 0.7 2],1000); %create random multivariate data;
%X3 = mvnrnd([0;0],[2 0.7;0.7 2],1000);
%X3 = mvnrnd([3;2],[2 0.7;0.7 2],1000);
%calcualte the mean difference between of X1 and X2;


dX=transpose(mean(X2,1)-mean(X1,1));


%Calculate the covariance matrix of the union of X1 and X2
U = union(X1,X2,'rows');
S=cov(U); 

%Calculate eigen values and eigen vectors of the covariance matrix
[V,D] = eig(S); 

%Sort eigen values and eigen vectors
[~,I]=sort(max(D),'descend');
D=D(:,I);
D=sum(D);
V=V(:,I);
%calcualte distance
Distance=sqrt(sum(((V'*dX)').^2./D))

%figure
%scatter3(X1(:,1),X1(:,2),X1(:,3))
%hold on
%scatter3(X2(:,1),X2(:,2),X2(:,3))








