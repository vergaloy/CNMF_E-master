function out=cluster_mean_activities(Pa)
rng('default')
a=Pa;% ./prctile(Pa,95,1);
a(a>1)=1;
ix=~(sum(a,2)==0);
a=a(ix,:);
b=a./prctile(a,95,2);
b(b>1)=1;


[~,HM,Z,L,clus]=linkage_thr(a','plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','ward');
plot_cluster_heatmap_means(HM,Z,L,clus);

[clut,~,Z2,L2,~]=linkage_thr(b,'plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','ward');
% c = cluster(Z2,'Maxclust',2);
c=max(clut.*(1:size(clut,2)),[],2);
for i=1:max(c)
clus1{i,1}=find(c==i);
end
% figure;plot_cluster_heatmap(HM2,Z2,L2,clus1);
% figure;plot_cluster_heatmap2D(b,Z,L,clus,Z2,L2,clus1)

c2 = cluster(Z2,'Maxclust',2);
for i=1:max(c2)
clus2{i,1}=find(c2==i);
end
% [~,HM,Z,L,clus]=Cluster_data_PV(a2','plotme',1,'remove_0s',0,'Cdist','cosine','Cmethod','average','selective',0)

K2=c2;
out=zeros(size(Pa,1),1);
out(ix)=K2;