% RECREATE PAPER3
%% Load Data
bin=1;
sf=5;
data=load_mice_data();  %load data

values={'HC','preS','postS','Test'};   
[mice_sleep,hyp,N]=group_mice_data2(data);
% [mice_sleep_all]=group_mice_data(data);
% [Da,aa,ata]=bin_mice_sleep(mice_sleep_all,1:size(mice_sleep_all,2),bin);
[D,a,at]=bin_mice_sleep(mice_sleep,1:size(mice_sleep,2),bin);
rng('default');
Rs=randperm(size(at,1));

box_bootstrap(D([1,2,3,5]),10)
stats_sleep(D{1,4},hyp,N,5,1)
at2=a;
at2=at2./prctile(at2,95,1);
% at2(at2>1)=1;
%% Get significant Clusters of predominantly active neurons
% clusters neurons


plot_heatmap_PV(at(Rs,[1,2,3,5]),'colormap','hot','GridLines','-','y_labels',values);

ix=cluster_mean_activities(at(:,[1,2,3,5]));
% ix=cluster_mean_activities(at2(:,[1,2,3,4,5,6,7,8]));
shuff=shuffle_row(at(Rs,[1,2,3,5]));
cluster_mean_activities(shuff);

a3=a2./prctile(a2,95,2);
a3(a3>1)=1;
a3(isnan(a3))=0;
[~,HM,Z,L,clus]=linkage_thr(a3,'plotme',1,'remove_0s',0,'Cdist','euclidean','Cmethod','ward');
plot_cluster_heatmap_means(HM,Z,L,clus);

 
%% Get patterns across sessions
[Ws,Hs,Xs]=get_clusters_activity_shift_windows(mice_sleep,3,bin);
[W,H,X]=get_cluster_activtiy_by_NMF_batch(Xs,Ws,Hs,1);

[si,RS]= get_remapping_cells_PV2(a,D,N,hyp,5,1)


CI=get_overlap_above_chance(IX(:,2)==1,si'==2)






