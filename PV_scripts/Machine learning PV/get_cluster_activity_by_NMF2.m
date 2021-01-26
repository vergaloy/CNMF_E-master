function [W,H]=get_cluster_activity_by_NMF2(X,K)
% [w,h]=get_cluster_activity_by_NMF2(b,k,5)
%     X(X>0)=1;
    a=sum(K,2)>0;
    X2=X(sum(K,2)>0,:);
    k=get_patterns(X2);
    [w,~] = seqNMF(X2,'K',k, 'L', 1,'lambda', 0,'maxiter',100,'showplot',0,'lambdaOrthoW',1);
%     w(w<1)=0;
    indempty = sum(sum(w>0,1),3)==0; % W is literally empty
    Wflat = sum(w,3);
    indempty = indempty | (max(Wflat,[],1).^2> .999*sum(Wflat.^2,1)); % or one neuron has >99.9% of the power
    w=w(:,~indempty,:);
    H=get_h_main(X2,w);
    W=zeros(size(a,1),size(w,2));
    W(a,:)=w;
%     [perm1,perm2]=sort_w(W,H);
%     figure; SimpleWHPlot_PV(W(perm1,perm2),H(perm2,:),X(perm1,:));

    
end

function [W,H]=get_W_H(tempX,tempK,l)
W=zeros(size(tempX,1), size(tempK,2),l);
H=zeros(size(tempK,2), size(tempX,2));
for i=1:size(tempK,2)
    temp=tempX(logical(tempK(:,i)),:);
    [w,~] = seqNMF(temp,'K',1, 'L', l,'lambda', 0,'maxiter',100,'showplot',0);
    W(logical(tempK(:,i)),i,:)=w;
    h=get_h(temp,w);
    H(i,:)=h;
end
end


function h=get_h(in,w)
len=size(w,3);
[~,h] = seqNMF(in,'K',1, 'L', len,'lambda', 0,'maxiter',20,'showplot',0,'W_init',w,'W_fixed',1);
s=[];
parfor i=1:1000
    temp = circshift_columns(in')';
    [~,h_t]=seqNMF(temp,'K',1, 'L', len,'lambda', 0,'maxiter',20,'showplot',0,'W_init',w,'W_fixed',1);
%     temp=xCosine(temp,w,m);
%     temp(temp==0)=[];
     h_t(h_t==0)=[];
    s=[s;h_t'];
end
h(h<prctile(s,95))=0;
end  




