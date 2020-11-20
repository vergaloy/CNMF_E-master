function get_correlations_similarity(mice_sleep)


for i=1:size(mice_sleep,2)
    s=[];
    for j=1:size(mice_sleep,1)
    temp=bin_data(mice_sleep{j,i},5,1); 
    temp=1-pdist(temp,@cross_cosine_dist,1);
    s=[s,temp];
    end
    S(:,i)=s';
end
S(isnan(S))=0;
[~,HM,Z,L,clus]=Cluster_data_PV(S','plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','ward');
 plot_cluster_heatmap_means(HM,Z,L,clus);