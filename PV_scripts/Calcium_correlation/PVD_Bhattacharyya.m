function distance=PVD_Bhattacharyya(X1,X2)


%rng('default') % For reproducibility
%co=0.95; %correlation fo the data
%X1 = transpose(mvnrnd([0;0],[1 co;co 1],1000)); %create random multivariate data;
%X2 = transpose(mvnrnd([0;0],[1 -co;-co 1],1000)); %create random multivariate data;

%preprocess data
X1(isnan(X1))=0;
X2(isnan(X2))=0;
X1(isinf(X1))=0;
X2(isinf(X2))=0;
k1=sum(X1,2);
k1(k1>0)=1;
k2=sum(X2,2);
k2(k2>0)=1;
k=k1.*k2;
X1(~logical(k),:)=[];
X2(~logical(k),:)=[];
X1=X1+abs(rand(size(X1,1),size(X1,2))./exp(10));
X2=X2+abs(rand(size(X2,1),size(X2,2))./exp(10)); 

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



