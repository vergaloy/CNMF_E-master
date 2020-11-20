function [W,H,X]=get_clusters_across_sessions(mice_sleep)
% [K,B]=get_clusters_across_sessions(mice_sleep);
warning off
K=cell(size(mice_sleep,1),size(mice_sleep,2));
sf=5;
bin=1;

%%
for i=1:size(K,1)
    i
    for j=1:size(K,2)
        j
        temp=bin_data(mice_sleep{i,j},sf,bin);
        try
            k=Cluster_data_PV(temp,'remove_0s',1,...
                'Cmethod','complete','Cdist',@cross_cosine_dist,'m',1,'plotme',0);
            
            [w,h]=get_cluster_activity_by_NMF(temp,k,1);
             [~,L]=sort(sum(w./max(w,[],1)+(w>0).*flip(1:size(w,2)),2),'descend');
             figure; SimpleWHPlot(w(L,:,:),h,temp(L,:)); title('SeqNMF factors, with raw data')
             W{i,j}=w;
             H{i,j}=h;
             X{i,j}=temp;
        catch
            cprintf('*blue','K is empty at i=%i, and j=%i.\n',i,j)
             W{i,j}=[];
             H{i,j}=[];
             X{i,j}=temp;
        end
    end
end



%%




