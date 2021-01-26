% RECREATE PAPER2
%% Load Data
bin=2;
sf=5;
data=load_mice_data();  %load data
[mice_sleep,hyp]=group_mice_data(data);
[D,a,at]=bin_mice_sleep(mice_sleep,1:size(mice_sleep,2),bin);
[active,mice_sleep]=get_inactive_cells(mice_sleep,D,[1,2,3,8,9]);
[D,a,at]=bin_mice_sleep(mice_sleep,1:size(mice_sleep,2),bin);


%% Get significant Clusters of predominantly active neurons
% clusters neurons
a=a(:,[1,2,3,8,9]);
% at2(at2>1)=1;
ix=cluster_mean_activities(a2);

 at=[mean(a(:,[1,2,3]),2),mean(a(:,[8,9]),2)];
 at=at./prctile(at,95,1);
 at(at>1)=1;
 re=at(:,1)-at(:,2);
 
 
%% Get patterns across sessions
[W1,H1,X1]=get_clusters_across_joint_sessions(mice_sleep,[1,2,3],3,bin);
[Wall1,Hall1,Xall1]=get_cluster_activtiy_by_NMF_batch(Xs,Ws,Hs,1);
[W2,H2,X2]=get_clusters_across_joint_sessions(mice_sleep,[8,9],3,bin);
[Wall2,Hall2,Xall2]=get_cluster_activtiy_by_NMF_batch(X2,W2,H2,1);

%% get pattern stats
Wc=catpad(2,Wall1{1, 1},Wall2{1, 1});
X=catpad(2,Xall1{1, 1},Xall2{1, 1});
Hc=blkdiag(Hall1{1, 1},Hall2{1, 1});
S=[size(D{1,1},2),size(D{1,2},2),size(D{1,3},2),size(D{1,8},2),size(D{1,9},2)];
% Wc(Wc<1)=0;
 f=Wc>0;
 Wc(:,sum(f,1)<4)=[];
% indempty = sum(sum(Wc>0,1),3)==0; % W is literally empty
% indempty = indempty | (max(Wc,[],1).^2> .95*sum(Wc.^2,1)); % or one neuron has >99.9% of the power
% Wc=Wc(:,~indempty,:);
[pix,pa]=get_pattern_cell_ix(X,Wc,S);



N=bin_activity(mice_sleep,7,5);
a2=[a(:,1),a(:,2),a(:,3),N,a(:,8),a(:,9)];


[pCI,pP]=compare_cell_ensambles_activity(a2,pix,0);
[pCI2,pP2]=compare_cell_ensambles_activity(a2,pix,1);
[nCI,nP]=compare_cell_ensambles_activity_NREM(mice_sleep,pix);

pix2=double(pix>0);
[pCI3,pP3]=compare_cell_ensambles_activity(a2,pix2,0);
[mean(pix==0),mean(pix==1),mean(pix==2)]*100

at3=at(:,[1,2,3,8,9]);
plot_heatmap_cell_separated(at3,pix);

pattern_distances(pix,data,active);

a3=sum(a(:,[1,2,3,8,9]),2);
logistic_regresion_activity(a3,pix2)

