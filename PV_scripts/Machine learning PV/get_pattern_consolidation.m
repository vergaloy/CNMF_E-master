function [out,Pa]=get_pattern_consolidation(Xall,Pid,Pat)

k=0;
for i=1:max(Pid)
%     if (sum(Pid==i)>1)
        k=k+1;
        temp=Pat(:,Pid==i);
        temp=median(temp,2);
        w(:,k)=temp;
%     end
end

w(:,sum(w>0.5,1)<3)=[];
X=catpad(2,Xall{:}); 
h=get_h_main(X,w,1); 


 h=conv2(1,gausswin(5),h,'same');
 h(h>0)=1;

[~,ls]=sort(sum(w./max(w,[],1)+(w>0).*flip(1:size(w,2)),2),'descend');
figure; SimpleWHPlot_PV(w(ls,:,:),h,X(ls,:)); 

% k=1470
% h2=h(:,k+1:k+size(Xall{1, 4},2));
% x2=Xall{1, 4} ; 
%[~,ls]=sort(sum(w./max(w,[],1)+(w>0).*flip(1:size(w,2)),2),'descend');
% figure; SimpleWHPlot(w(ls,:,:),h2,x2(ls,:)); title('SeqNMF factors, with raw data')

k=0;
for i=1:size(Xall,2) 
    x=Xall{1, i};
    I=x;
    ht=h(:,k+1:k+size(Xall{1, i},2));
    I(w*ht==0)=0;
    I(isnan(x))=nan;
    I=nanmean(I,2);
    Pa(:,i)=I;
    p(:,i)=nanmean(ht,2);
    k=k+size(Xall{1, i},2);
end

 [~,HM,Z,L,clus]=Cluster_data_PV(Pa','plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','average');
  plot_cluster_heatmap_means(HM,Z,L,clus);
  
  a2=Pa./prctile(Pa,99,1);
  ix=~(sum(a2,2)==0);
  a2=a2(ix,:);

  [K2,HM2,Z2,L2,clus2]=Cluster_data_PV(a2,'plotme',0,'remove_0s',0,'Cdist','cosine','Cmethod','complete');
   figure;plot_cluster_heatmap(HM2,Z2,L2,clus2);
  figure;plot_cluster_heatmap2D(a2,Z,L,clus,Z2,L2,clus2)
  
  K2=sum(K2.*(1:size(K2,2)),2);
  
  out=zeros(size(w,1),1);
  out(ix)=K2;
end


function [H]=get_h_main(X,W,l)

for i=1:size(W,2)
    w=W(:,i);
    x=X(w>0,:);
    w(w==0)=[];
    x(:,isnan(sum(x,1)))=0;
    h=get_h(x,w,l);
    H(i,:)=h;
end
end




    
function h=get_h(in,w,m)
n=ceil(size(in,1));
h=w\in;
% h=xCosine(in,w,m);
s=[];
% h=[h,zeros(1,m)];
parfor i=1:1000
    temp = circshift_columns(in')';
    h_t=w\temp;
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