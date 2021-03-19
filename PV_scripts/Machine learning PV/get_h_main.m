function [H]=get_h_main(X,W)
 X(X>0)=1;
for i=1:size(W,2)
    w=W(:,i,:);
    wt=squeeze(mean(w,3));
    x=X(wt>0,:);
    w(wt==0,:,:)=[];
    x(:,isnan(sum(x,1)))=0;
%     w(w>0)=1;
%     x(x>0)=1;
    
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
