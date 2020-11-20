% RECREATE PAPER2
%% Load Data
data=load_mice_data();  %load data
[mice_sleep,hyp]=group_mice_data(data);
[D,a,at]=bin_mice_sleep(mice_sleep);
%% Get significant Clusters of predominantly active neurons
% clusters neurons
% [K1,AU1,BP1]=Multiscale_Bootstrap(zscore(a),'plotme',1);
% clusters conditions
at2=at(:,[1,2,3,8,9]);
at2(at2>1)=1;
[~,HM,Z,L,clus]=linkage_thr(at2','plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','complete');
 plot_cluster_heatmap_means(HM,Z,L,clus);
 

%% Get patterns across sessions
[W1,H1,X1]=get_clusters_across_joint_sessions(mice_sleep,[1,2,3],1);
[Wall1,Hall1,Xall1]=get_cluster_activtiy_by_NMF_batch(X1,W1,H1,1);

[W2,H2,X2]=get_clusters_across_joint_sessions(mice_sleep,[8,9],3);
[Wall2,Hall2,Xall2]=get_cluster_activtiy_by_NMF_batch(X2,W2,H2,1);
%% get pattern stats

Wc=catpad(2,Wall1{1, 1},Wall2{1, 1});
X=catpad(2,Xall1{1, 1},Xall2{1, 1});
S=[size(mice_sleep{1,1},2),size(mice_sleep{1,2},2),size(mice_sleep{1,3},2),size(mice_sleep{1,8},2),size(mice_sleep{1,9},2)]/5;
[ix,Pa]=get_pattern_consolidation2(X,Wc,S);


[CI,P,P2]=compare_cell_ensambles_activity(ix,a);

N=bin_activity(mice_sleep,7,ix,10);
[nCI,nP,nP2]=compare_cell_ensambles_activity(ix,N);

R=bin_activity(mice_sleep,7,ix,10);
[rCI,rP,rP2]=compare_cell_ensambles_activity(ix,R);

% [Patter_stats,Rep,Pat,Pid]=pattern_stats(Xall,Wall,Hall,W);





