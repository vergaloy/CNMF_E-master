% RECREATE PAPER
%% Load Data
data=load_mice_data();  %load data
[mice_sleep,hyp]=group_mice_data(data);
[D,a,at]=bin_mice_sleep(mice_sleep);
%% Get significant Clusters of predominantly active neurons
% clusters neurons
% [K1,AU1,BP1]=Multiscale_Bootstrap(zscore(a),'plotme',1);
% clusters conditions
[~,HM,Z,L,clus]=Cluster_data_PV(a','plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','complete');
 plot_cluster_heatmap_means(HM,Z,L,clus);
 

%% Get patterns across sessions
[W,H,X]=get_clusters_across_sessions(mice_sleep);
[Wall,Hall,Xall]=get_cluster_activtiy_by_NMF_batch(X,W,H,1);
%% get pattern stats
[Patter_stats,Rep,Pat,Pid]=pattern_stats(Xall,Wall,Hall,W);
[ix,Pa]=get_pattern_consolidation(Xall,Pid,Pat);
[CI,P,P2]=compare_cell_ensambles_activity(ix,a);
