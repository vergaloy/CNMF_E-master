function plot_heatmap_cell_separated(a,ix)
ix=double(ix>0);
for i=0:max(ix)   
at3=a(ix==i,:);
at3=at3./prctile(at3,95,1);
at3(at3>1)=1;
[~,HM,Z,L,clus]=linkage_thr(at3','plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','average');
plot_cluster_heatmap_means(HM,Z,L,clus);
end