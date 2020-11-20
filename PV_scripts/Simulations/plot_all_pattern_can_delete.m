
[D,a]=bin_mice_sleep(mice_sleep);
A=catpad(2,D{:});

T{1}=A(1:37,:);
T{2}=A(38:51,:);
T{3}=A(52:65,:);

for i=1:length(T)
    temp=T{i};
    temp(:,isnan(sum(temp,1)))=[];
    k=Cluster_data_PV(temp,'remove_0s',1,...
    'Cmethod','complete','Cdist',@cross_cosine_dist,'m',1,'plotme',1);
[w,h]=get_cluster_activity_by_NMF(temp,k,1);

[~,L]=sort(sum(w./max(w,[],1)+(w>0).*flip(1:size(w,2)),2),'descend');
figure; SimpleWHPlot(w(L,:,:),h,temp(L,:)); title('SeqNMF factors, with raw data')
xline(590)
xline(590+590)
xline(590+590+290)
xline(590+590+290+590)


