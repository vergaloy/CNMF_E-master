function corr_similarity(mice_sleep,distance)

sf=5;
bin=1;
S=cell(size(mice_sleep,1),size(mice_sleep,2));
for i=1:numel(mice_sleep)
    in=bin_data(mice_sleep{i},sf,bin);
    out=1-pdist(in,distance);
    out(isnan(out))=0;
    S{i}=out;
end

for i=1:size(S,2)
    temp=S(:,i);
    C(:,i)=catpad(2,temp{:});
end


[K1,AU,BP]=Cluster_data_PV(C','plotme',1,'Standarize','none','remove_0s',0,'cluster_distance_matrix','cosine','Cdist','euclidean','Cmethod','ward');

% [K1,AU,BP]=Cluster_data_PV(C','plotme',1,'Standarize','none','remove_0s',0,'Cdist','cosine','Cmethod','average');

X=catpad(2,D{[1,2,3,8,9]});

[Ka,~,~,ha,~]=Cluster_data_PV(X,'remove_0s',1,...
    'Cmethod','ward','Cdist','euclidean','LeafOrder',0,...
    'Standarize','none','cluster_distance_matrix','cosine',...   %'cluster_distance_matrix',@cross_corr_distance
    'alpha',0.2,'plotme',1);


[w,h]=get_cluster_activity_by_NMF(X,Ka,2);


[~, ~, ~, hybrid] = helper.ClusterByFactor(w(:,:,:),1);
indSort = hybrid(:,3);
    figure; SimpleWHPlot(w(indSort,:,:),h,X(indSort,:)); title('SeqNMF factors, with raw data')
    axdrag

