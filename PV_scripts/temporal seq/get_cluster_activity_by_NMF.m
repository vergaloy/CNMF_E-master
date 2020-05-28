function [W,H,indSort]=get_cluster_activity_by_NMF(X,Clust,showplot)
% [W,H,indSort]=get_cluster_activity_by_NMF(temp,Clust,1);


L = 1; %need to be odd
lambda =0;  %0.3 dev



W0(1:size(X,1),1:max(Clust))=0;
H0(1:max(Clust),1:size(X,2))=0;
for i=1:max(Clust)
    I=Clust==i;
    T=X(I,:);
    [W0(I,i),H0(i,:)]=NMF(T,1);
end


W0=cat_with_0(W0,L);
[W,H] = seqNMF(X,'K',size(W0,2), 'L', L,'lambda', lambda,'maxiter',100,'showplot',0,'lambdaOrthoH',1,'W_init',W0,'H_init',H0);


 [~, ~, ~, hybrid] = helper.ClusterByFactor(W(:,:,:),1);
 indSort = hybrid(:,3);
 if (showplot)
    figure; SimpleWHPlot(W(indSort,:,:),H,X(indSort,:)); title('SeqNMF factors, with raw data')
    axdrag
 end

end

function W=cat_with_0(W,L)
c=floor(L/2);
W=cat(3,zeros(size(W,1),size(W,2),c),W);
W=cat(3,W,zeros(size(W,1),size(W,2),c));
end



