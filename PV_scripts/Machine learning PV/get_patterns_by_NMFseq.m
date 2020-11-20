function get_patterns_by_NMFseq(datain,Cdist)
% get_patterns_by_NMFseq(bin_data(mice_sleep{1,3},5,2),'correlation')
%% remove zeros



[datain,active]=remove_zeros(datain);
datain=squareform(1-pdist(datain,Cdist));
datain(datain<0)=0;
[w,h] = seqNMF(datain,'K',2, 'L', 1,'lambda', 0,'maxiter',100,'showplot',0);

[~, ~, ~, hybrid] = helper.ClusterByFactor(w(:,:,:),1);
indSort = hybrid(:,3);      
figure; SimpleWHPlot(w(indSort,:,:),h,datain(indSort,indSort)); title('SeqNMF factors, with raw data')



end



function [data,active]=remove_zeros(data)
len=size(data,2);
active=data;
active(active~=0)=1;
active=1-mean(active,2);
active=active.^len;
active=active<0.05;
data=data(active,:);
end