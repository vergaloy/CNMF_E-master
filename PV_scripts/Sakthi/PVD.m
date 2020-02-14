
function distance=PVD(X1,X2,dim)

%rng('default') % For reproducibility
X1 = transpose(mvnrnd([.003;0.007;0.005],[1 0.7 0.3;0.7 1 0.7;0.3 0.7 1],1000)); %create random multivariate data;
X2 = transpose(mvnrnd([1;0.7;0.005],[1 0.7 0.3;0.7 1 0.7;0.3 0.7 1],1000)); %create random multivariate data;
X3 = transpose(mvnrnd([0.003;0.007;0.005],[1 0.7 0.3;0.7 1 0.7;0.3 0.7 1],1000)); %create random multivariate data;

data = mvnrnd([1;1],[1 0.7;0.7 1],1000); %create random multivariate data;

data(data<1)=0;
X2(X2<1)=0;
X3(X3<1)=0;


X1(isnan(X1))=0;
X2(isnan(X2))=0;
X1(isinf(X1))=0;
X2(isinf(X2))=0;

f=[X1,X2];
f(f>0)=1;
I=sum(f,2);



I=I<8;
X1(I,:)=[];
X2(I,:)=[];

X1=multivariate_bootstrap(X1,1000);
X2=multivariate_bootstrap(X2,1000);

m=mean(X1,2);
s=std(X1,[],2);
X1=(X1-m)./s;
X2=(X2-m)./s;

I=mean(X2,2)-mean(X1,2);
[~,I]=sort(I,'descend');
X1=X1(I,:);
X2=X2(I,:);
%imagesc([X1,X2])


%% Calculate PVD
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
%sqrt(dX'*(S^-1)*dX);










