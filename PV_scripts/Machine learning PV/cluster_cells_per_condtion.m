function cluster_cells_per_condtion(mice_sleep);

sim=1000;
ref=[1,2,3,8,9];
out=cell(2,5);
len=1450;
to_svm=kill_inactive_neurons(mice_sleep,len,ref);
to_svm=to_svm(:,ref);
[D,a]=bin_mice_sleep(to_svm,[1,2,3,4,5],2);

for i=1:size(D,2)
    temp=D{1, i};
    temp=D{1, i}+randn(size(D{1,i},1),size(D{1,i},2))*0.001;
    dist = squareform(pdist(temp,'cosine'));
    dist(isnan(dist))=1;
    Z = linkage(dist);
    out=get_significant_linkage(temp);
    thr=Z(find(Z(:,3)-prctile(out,95,2)>0,1),3);
    
    [~,~,outperm] =dendrogram(Z,0,'ColorThreshold',thr);
end

end

function out=get_significant_linkage(in);

sim=1000;

for s=1:sim
    temp=circshift_columns(in')';
    dist = squareform(pdist(temp,'cosin'));
    dist(isnan(dist))=1;
    Z = linkage(dist);
    out(:,s)=Z(:,3);
end

end


