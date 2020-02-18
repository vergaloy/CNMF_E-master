function distance=PVD_Hellinger(X1,X2)


%rng('default') % For reproducibility
%   co=0.5; %correlation fo the data
%   X1 = transpose(mvnrnd([0;0],[1 0;0 1],1000)); %create random multivariate data;
%   X2 = transpose(mvnrnd([0;0],[1 co;co 1],1000)); %create random multivariate data;
[X1,X2]=stabilize_matrix(X1,X2);  
%calculate mean and covariance matrix
M1=mean(X1,2);
M2=mean(X2,2);
S1=cov(X1');
S2=cov(X2');
S=(S1+S2)/2;

%calculate determinar by svd.
[~,d1,~]=svd(S1);
d1=log(d1);
d1=vpa(sum(diag(d1)));
[~,d2,~]=svd(S2);
d2=log(d2);
d2=vpa(sum(diag(d2)));
[~,d,~]=svd(S);
d=log(d);
d=vpa(sum(diag(d)));

d1=exp(d1);
d2=exp(d2);
d=exp(d);

distance=sqrt(  1-(((d1^0.25)*(d2^0.25))/d^0.5)*exp(-(1/8)*(M1-M2)'*(((d1+d2)/2)^-1)*(M1-M2))  );

end



