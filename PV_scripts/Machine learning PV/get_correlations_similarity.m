function get_correlations_similarity(mice_sleep)

sf=5;
bin=1;

for i=1:size(mice_sleep,2)
    s=[];
    for j=1:size(mice_sleep,1)
    temp=bin_data(mice_sleep{j,i},sf,bin); 
    temp=1-pdist(temp,'cosine');
    s=[s,temp];
    end
    S(:,i)=s';
end
S(isnan(S))=0;
S=S(:,[1,2,3,5,6]);

[~,HM,Z,L,clus]=linkage_thr(S','plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','ward');
plot_cluster_heatmap_means(HM,Z,L,clus);