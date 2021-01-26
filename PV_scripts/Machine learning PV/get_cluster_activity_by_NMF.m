function [w,h]=get_cluster_activity_by_NMF(X,K,len)
% [w,h]=get_cluster_activity_by_NMF(b,k,5)
 X(X>0)=1;
    [w,h]=get_W_H(X,K,len);
     w(w<1)=0;
 indempty = sum(sum(w>0,1),3)==0; % W is literally empty   
 indempty = indempty | (max(w,[],1).^2> .95*sum(w.^2,1)); % or one neuron has >99.9% of the power

    w=w(:,~indempty,:);
    h=h(~indempty,:);

    
    
    
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




