function [W0,H0]=intial_seqNMF(X,k)


parfor i=1:100   
    [W,H,c,~,po(i)] = seqNMF(X,'K',k, 'L', 1,'lambda', 0,'maxiter',10,'showplot',0,'lambdaOrthoW',1); 
    Ws{i}=W;
    Hs{i}=H;
    cost(i)=c(11);   
end

[~,I]=min(cost);
W0=Ws{I};
H0=Hs{I};