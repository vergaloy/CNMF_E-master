function [W,H] = get_most_likely_pattern(W1,H1,k,numfits)
% ------------------------------------------------------------------------
% USAGE:  
% ------------------------------------------------------------------------
% INPUTS
% H1 and W1 are the output of a convNMF fit with K factors
% H2 and W2 are the output of a different convNMF with the same K.
% ------------------------------------------------------------------------
% OUTPUTS
% diss:     Diss is a measure of the disssimilarity of two factorizations.
% ------------------------------------------------------------------------
% Emily Mackevicius and Andrew Bahle
% adapted from Wu et al 2016


    K = size(W1,2);
%     b=nchoosek(1:K,2);
%     loop=size(b,1);
%     C(1:loop)=0;
%     parfor i = 1:loop       
%         Xhat1 = helper.reconstruct(W1(:,b(i,1),:),H1(b(i,1),:));
%         Xhat2 = helper.reconstruct(W1(:,b(i,2),:),H1(b(i,2),:));
%         C(i) = (Xhat1(:)'*Xhat2(:))/((sqrt(Xhat1(:)'*Xhat1(:))*sqrt(Xhat2(:)'*Xhat2(:)))+eps);
%     end
%     M = zeros(K, K);
%     for i=1:loop
%     M(b(i,1),b(i,2))=C(i);
%     end
%     M=(M+M')+diag(ones(1,K));
    
    
    
    idx = kmeans(W1',k);

    
    T=[];
    for i=1:k
        T=[T,W1(:,idx==i)];
       	P(i)=size(W1(:,idx==i),2);
        co(i)=mean_correlation(W1(:,idx==i));
        W(:,i)=median(W1(:,idx==i),2);
        H(i,:)=median(H1(idx==i,:),1);
    end
      
%     t_pat=max(P(co>=0.5));
%     P(co<0.5)=0;
%     P=P./numfits;
%     
%     W(:,P<0.5)=[];
%     H(P<0.5,:)=[];


     
%     Wt=W./max(W,[],1);
    s=sum(W>0.01,1);
    W(:,s<=3)=[];
    H(s<=3,:)=[];    
    
end



function co=mean_correlation(pat)
c=triu(corr(pat),1);
co=mean(c(c>0));
end