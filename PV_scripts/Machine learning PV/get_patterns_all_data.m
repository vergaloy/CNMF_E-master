
t=D(1,[1,2,3,8,9]);
A=catpad(2,t{:});

k=Cluster_data_PV(A,'remove_0s',1,...
    'Cmethod','complete','Cdist',@cross_cosine_dist,'m',1,'plotme',1);
[w,h]=get_cluster_activity_by_NMF(A,k,1);
[~,L]=sort(sum(w./max(w,[],1)+(w>0).*flip(1:size(w,2)),2),'descend');
figure; SimpleWHPlot(w(L,:,:),h,A(L,:)); title('SeqNMF factors, with raw data')
xline(590)
xline(590+590)
xline(590+590+290)
xline(590+590+290+590)


