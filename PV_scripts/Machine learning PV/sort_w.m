function [perm1,perm2]=sort_w(wt,h);
Z=linkage(wt*h,'ward','cosine');
perm1 = order_tree(Z);
t=(1:size(wt,1))'*ones(1,size(wt,2)).*double(wt(perm1,:)>0);
t(t==0)=nan;
[~,perm2]=sort(nanmedian(t,1));

% imagesc(wt(perm1 ,perm2));

