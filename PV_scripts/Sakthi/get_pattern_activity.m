function get_pattern_activity(X,W,H,C)



t=0;
[max_factor, L_sort, max_sort, hybrid] = helper.ClusterByFactor(W(:,:,:),1);
indSort = hybrid(:,3);

for i=1:size(C,2) 
    m(i)=mean(C{1, i},'all');
    t(i+1)=t(i)+size(C{1, i},2);
    D=H(:,t(i)+1:t(i+1));
    D(D==0)=nan;
    hm(:,i)=nanmean(D,2);
    
   % figure; SimpleWHPlot(W(indSort,:,:),H(:,t(i)+1:t(i+1)),X(indSort,t(i)+1:t(i+1))); title('SeqNMF factors, with raw data')
    
end
hm
hm./m