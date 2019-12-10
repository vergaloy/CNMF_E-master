function d=PVD_Bhattacharyya(X1,X2)


%rng('default') % For reproducibility
%co=0; %correlation fo the data
%X1 = transpose(mvnrnd([0;0],[1 co;co 1],1000)); %create random multivariate data;
%X2 = transpose(mvnrnd([100;100],[1 co;co 1],1000)); %create random multivariate data;

X1(isnan(X1))=0;
X2(isnan(X2))=0;
X1(isinf(X1))=0;
X2(isinf(X2))=0;
%X1=X1./(max(X1,[],'all'));
%X2=X2./(max(X2,[],'all'));

X1=X1+abs(rand(size(X1,1),size(X1,2))/1000);
X2=X2+abs(rand(size(X2,1),size(X2,2))/1000);
%calcualte the mean difference between of X1 and X2;
M1=mean(X1,2);
M2=mean(X2,2);
S1=cov(X1');
S2=cov(X2');
S=(S1+S2)/2;


d1=vpi(det(S1));
d2=vpi(det(S2));
d=vpi(det(S));

de=log(d/sqrt(d1*d2))-log(10^(2*(scal)))


distance=0.125*(M1-M2)'*S^-1*(M1-M2)+0.5*log(((d/scal)/sqrt(d1*d2)/scal))

scal=1;
d1=det(S1*scal);
d2=det(S2*scal);
d=det(S*scal);
distance2=0.125*(M1-M2)'*S^-1*(M1-M2)+0.5*log((d/sqrt(d1*d2))/scal)
