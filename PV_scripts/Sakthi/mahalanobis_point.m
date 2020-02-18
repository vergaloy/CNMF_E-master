function distance=mahalanobis_point(X1,P)

%rng('default') % For reproducibility
%X1 = transpose(mvnrnd([3;7;5],[2 0.7 0.3;0.7 2 0.7;0.3 0.7 2],1000)); %create random multivariate data;
%X2 = transpose(mvnrnd([0;0;5],[2 0.7 0.3;0.7 2 0.7;0.3 0.7 2],1000)); %create random multivariate data;
%  X1 = mvnrnd([0;0],[1 0;0 1],1000); %create random multivariate data;
%  X2 = mvnrnd([0;0],[1 0.5;0.5 1],1000); %create random multivariate data;

X1(isnan(X1))=0;
X1(isinf(X1))=0;

%calcualte the mean difference between of X1 and X2;
M1=mean(X1,1);
M2=mean(P,1);
S=cov(X1);
dx=M2-M1;

distance=sqrt(dx*pinv(S)*dx');