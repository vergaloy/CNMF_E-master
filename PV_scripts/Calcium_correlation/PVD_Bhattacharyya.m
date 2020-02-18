function distance=PVD_Bhattacharyya(X1,X2)


%rng('default') % For reproducibility
%co=0.95; %correlation fo the data
%X1 = transpose(mvnrnd([0;0],[1 co;co 1],1000)); %create random multivariate data;
%X2 = transpose(mvnrnd([0;0],[1 -co;-co 1],1000)); %create random multivariate data;
n1=size(X1,2);
n2=size(X2,2);

T=[X1,X2];
T=rescale(T);
X1=[T(:,1:n1)]*10;
X2=[T(:,n1+1:n1+n2)]*10;   
%calculate mean and covariance matrix
M1=mean(X1,2);
M2=mean(X2,2);
S1=cov(X1');
S2=cov(X2');
S=(S1+S2)/2;

%calculate determinar by svd.
[~,d1,~]=svd(S1);
d1=vpa(prod(diag(d1)));
[~,d2,~]=svd(S2);
d2=vpa(prod(diag(d2)));
[~,d,~]=svd(S);

d=vpa(prod(diag(d)));

distance=0.125*(M1-M2)'*pinv(S)*(M1-M2)+0.5*log(d/sqrt(d1*d2));



