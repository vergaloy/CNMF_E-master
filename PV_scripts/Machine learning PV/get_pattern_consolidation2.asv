function [out,Pa]=get_pattern_consolidation2(X,w,S)

% [out,Pa]=get_pattern_consolidation2(X,Wc);
h=get_h_main(X,w);







h=conv2(1,gausswin(size(w,3)),h,'same');
h(h>0)=1;

wt=squeeze(mean(w,3));
[~,L]=sort(sum(wt./max(wt,[],1)+(wt>0).*flip(1:size(wt,2)),2),'descend');


[max_factor, L_sort, max_sort, hybrid] = helper.ClusterByFactor(w(:,:,:),1);
L = hybrid(:,3);

figure; SimpleWHPlot_PV(w(L,:,:),h,X(L,:));



    I=X;
    I(reconstructPV(w,h)==0)=0;
%     figure; SimpleWHPlot_PV(wt(L,:,:),h,I(L,:));
    k=0;
    for i=1:size(S,2)
     Pa(:,i)=mean(I(:,k+1:k+S(i)),2);   
     k=k+S(i);         
    end

  a2=Pa./prctile(Pa,95,1);
  ix=~(sum(a2,2)==0);
  a2=a2(ix,:);
  a2(a2>1)=1;
    
    

 [~,HM,Z,L,clus]=linkage_thr(a2','plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','average');
  plot_cluster_heatmap_means(HM,Z,L,clus);
  
  [K2,HM2,Z2,L2,clus2]=linkage_thr(a2,'plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','average');
   figure;plot_cluster_heatmap(HM2,Z2,L2,clus2);
  figure;plot_cluster_heatmap2D(a2,Z,L,clus,Z2,L2,clus2)
  
  K2=sum(K2.*(1:size(K2,2)),2);
  
  out=zeros(size(w,1),1);
  out(ix)=K2;
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