function [Ws,Hs,Xs]=get_clusters_across_joint_sessions(mice_sleep,sessions,m)
% [Ws,Hs,Xs]=get_clusters_across_joint_sessions(mice_sleep,[1,2,3],5)
warning off
K=cell(size(mice_sleep,1),size(mice_sleep,2));
sf=5;
bin=1;

%%
for i=1:size(K,1)
    i

        D=mice_sleep(i,sessions);
        D=catpad(2,[],D{:});
        temp=bin_data(D,sf,bin);
        try
            a=temp(:);
            a(a==0)=[];
            th=prctile(a,95);
            temp=temp/th;
            temp(temp>1)=1;
            k=Cluster_data_PV(temp,'remove_0s',1,...
                'Cmethod','complete','Cdist',@cross_cosine_dist,'m',m,'plotme',0);           
            [w,h]=get_cluster_activity_by_NMF(temp,k,m);
            
            wt=squeeze(mean(w,3));
             [~,L]=sort(sum(wt./max(wt,[],1)+(wt>0).*flip(1:size(wt,2)),2),'descend');
             figure; SimpleWHPlot(wt(L,:,:),h,temp(L,:)); 
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
