function [Ws,Hs,Xs]=get_clusters_across_joint_sessions(mice_sleep,sessions,m,bin)
% [Ws,Hs,Xs]=get_clusters_across_joint_sessions(mice_sleep,[1,2,3],5)
warning off
K=cell(size(mice_sleep,1),size(mice_sleep,2));
sf=5;
rng('default'); % for reproducibility
%%
for i=1:size(K,1)
    i
    D=mice_sleep(i,sessions);
    D=catpad(2,[],D{:});
    temp=bin_data(D,sf,bin);
    try
        k=Cluster_data_PV(temp,'remove_0s',1,'Cmethod','ward','Cdist',@cross_cosine_dist,'m',m,'plotme',0);  %@cross_cosine_dist,'m',m
%            k=Cluster_data_PV(temp,'remove_0s',1,'Cmethod','ward','Cdist',@cross_cosine_dist,'m',m,'plotme',1);  
         [w,h]=get_cluster_activity_by_NMF2(temp,k); 
        wt=squeeze(mean(w,3));
        [perm1,perm2]=sort_w(wt,h);
%          figure; SimpleWHPlot_PV(wt(perm1,perm2,:),h(perm2,:),temp(perm1,:));       
        Ws{i,1}=w;
        Hs{i,1}=h;
        Xs{i,1}=temp;
        
    catch
        cprintf('*blue','K is empty at i=%i, and j=%i.\n',i)
        Ws{i,1}=[];
        Hs{i,1}=[];
        Xs{i,1}=temp;
    end
end



end



