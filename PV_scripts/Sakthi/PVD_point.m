
function distance=PVD_point(X1,P,dim)


%% Calculate PVD
M1=mean(X1,2)';

S=cov(X1'); 

%Calculate eigen values and eigen vectors of the covariance matrix
[V,D] = eig(S); 
   

dX=(P-M1)';
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










