function distance=mahalanobis_point(X1,P)

%rng('default') % For reproducibility
%X1 = transpose(mvnrnd([3;7;5],[2 0.7 0.3;0.7 2 0.7;0.3 0.7 2],1000)); %create random multivariate data;
%X2 = transpose(mvnrnd([0;0;5],[2 0.7 0.3;0.7 2 0.7;0.3 0.7 2],1000)); %create random multivariate data;



X1(isnan(X1))=0;
X1(isinf(X1))=0;

%calcualte the mean difference between of X1 and X2;
M1=mean(X1,2);
M2=mean(P,2);
S=cov(X1');
dx=M2-M1;

distance=sqrt(dx'*pinv(S)*dx);