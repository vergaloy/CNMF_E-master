function [w,h]=get_cluster_activity_by_NMF(X,K,len)
% [w,h]=get_cluster_activity_by_NMF(b,k,5)
X(X>0)=1;
    [w,h]=get_W_H(X,K,len);
    
    
    [pvals,is_significant] = test_significance(X,w,0.05);  
    is_significant(mean(h,2)==0)=0;
    w=w(:,is_significant,:);
    h=h(is_significant,:);

    
    
    
end

function [W,H]=get_W_H(tempX,tempK,l)
W=zeros(size(tempX,1), size(tempK,2),l);
H=zeros(size(tempK,2), size(tempX,2));
for i=1:size(tempK,2)
    temp=tempX(logical(tempK(:,i)),:);
    [w,h] = seqNMF(temp,'K',1, 'L', l,'lambda', 0,'maxiter',100,'showplot',0);
    W(logical(tempK(:,i)),i,:)=w;
    h=get_h(temp,w);
    H(i,:)=h;
end
end



% function h=get_h(in,w,m)
% n=ceil(size(in,1));
% h=xCosine(in,w,m);
% s=[];
% h=[h,zeros(1,m)];
% parfor i=1:1000
%     temp = circshift_columns(in')';
%     temp=xCosine(temp,w,m);
%     temp(temp==0)=[];
%     s(i)=prctile(temp,95);
% end
% h=h>prctile(s,95);
% end  



function h=get_h(in,w)
len=size(w,3);
[~,h] = seqNMF(in,'K',1, 'L', len,'lambda', 0,'maxiter',1,'showplot',0,'W_init',w);
s=[];
parfor i=1:1000
    temp = circshift_columns(in')';
    [~,h_t]=seqNMF(temp,'K',1, 'L', len,'lambda', 0,'maxiter',1,'showplot',0,'W_init',w);
%     temp=xCosine(temp,w,m);
%     temp(temp==0)=[];
     h_t(h_t==0)=[];
    s=[s;h_t'];
end
h(h<prctile(s,95))=0;
end  



function c=xCosine(in,w,m)
if (isempty(m))
    m=1;
end
for i=1:size(in,2)-m
%     c(i)=jaccard(w>0,in(:,i)>0); 
temp=in(:,i:i+m-1);
     c(i)=dot(w(:),temp(:))/(norm(w(:))*norm(temp(:)));   
end
c(isnan(c))=0;
end

