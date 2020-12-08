function a=get_mean_activity_clustered_by_patterns(X,w,S)
% [out,Pa]=get_pattern_consolidation2(X,Wc);
rng('default')


h=get_h_main(X,w);
[~,active]=remove_zeros(h);
w=w(:,active);
h=h(active,:);


h=conv2(1,gausswin(5),h,'same');
h(h>0)=1;

k=sum(h,2)==0;

h(k,:)=[];

wt=squeeze(mean(w,3));
wt(:,k)=[];
% [~, ~, ~, hybrid] = helper.ClusterByFactor(w(:,:,:),1);
% L = hybrid(:,3);
[perm1,perm2]=sort_w(wt,h);

figure; SimpleWHPlot_PV(wt(perm1,perm2),h(perm2,:),X(perm1,:));
I=X;
I(reconstructPV(wt,h)==0)=0;
%     figure; SimpleWHPlot_PV(wt(perm1,perm2),h,I(perm1,:));
% figure;imagesc(I(perm1,:));caxis([0 1])
% figure;imagesc(X(perm1,:));caxis([0 1])
k=0;

for i=1:size(S,2)
    a(:,i)=mean(I(:,k+1:k+S(i)),2);
    k=k+S(i);
end


end


function [H]=get_h_main(X,W)
for i=1:size(W,2)
    w=W(:,i,:);
    wt=squeeze(mean(w,3));
    x=X(wt>0,:);
    w(wt==0,:,:)=[];
    x(:,isnan(sum(x,1)))=0;
    w(w>0)=1;
    x(x>0)=1;
    
    h=get_h(x,w);
    H(i,:)=h;
end
end

function h=get_h(in,w)
len=size(w,3);
k=size(w,2);
[~,h] = seqNMF(in,'K',k, 'L', len,'lambda', 0,'maxiter',1,'showplot',0,'W_init',w);
s=[];
parfor i=1:1000
    temp = circshift_columns(in')';
    [~,h_t]=seqNMF(temp,'K',k, 'L', len,'lambda', 0,'maxiter',1,'showplot',0,'W_init',w);
    %     temp=xCosine(temp,w,m);
    %     temp(temp==0)=[];
    h_t(h_t==0)=[];
    s=[s;h_t'];
end
h(h<prctile(s,95))=0;
end

function [data,active]=remove_zeros(data)
len=size(data,2);
active=data;
active(active~=0)=1;
active=1-mean(active,2);
active=active.^len/2;
active=active<0.05;
data=data(active,:);
end