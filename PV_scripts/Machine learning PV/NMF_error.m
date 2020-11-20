function [k,P,P2]=NMF_error(mice_sleep)
% [k,P,P2]=NMF_error(mice_sleep);
tic
sim=1000;
for s=1:sim
 [b,~]=simulate_spike_activity(mice_sleep);       
 b(isnan(b))=0;
[k{s},~,~,~,P{s},P2{s}]=Cluster_data_PV(b,'remove_0s',1,...
'Cmethod','complete','Cdist','correlation','LeafOrder',0,...
'Standarize','none','cluster_distance_matrix','none',...   %'cluster_distance_matrix',@cross_corr_distance
'alpha',0.05,'plotme',0);
end
toc
