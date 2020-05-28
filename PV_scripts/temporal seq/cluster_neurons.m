function Clust=cluster_neurons(obj,showplot)
% Clust=cluster_neurons(temp,1); 
k=sum(obj,2)==0;

obj(k,:)=[];

t=acos(corr(obj','Type','Spearman'))./pi;             %2*single_pattern_MS(obj',0); 
 

for s=1:1000
    rsample=shuffle_rows(obj);
    rsample= acos(corr(rsample','Type','Spearman'))./pi;                       %2*single_pattern_MS(rsample',0);
    Z = linkage(squareform(rsample),'ward');
    Zr(:,s)=Z(:,3);
end
Zr=Zr(:);
Z = linkage(squareform(t),'ward');

c = cophenet(Z,squareform(t));

Clust = cluster(Z,'CutOff',prctile(Zr,5),'Criterion','distance');
Clust=cluster_data(Clust);
tclust=Clust;
Clust(1:size(k,1))=0;
Clust(~k)=tclust;


if (showplot==1)
[~,~,outperm] =dendrogram(Z,size(t,1),'ColorThreshold',prctile(Zr,5));
yline(prctile(Zr,5),'--')
t_sort=2*single_pattern_MS(obj(outperm,:)',0);
figure
subplot(1,2,1);
heatmap(t)
subplot(1,2,2);
heatmap(outperm,outperm,t_sort)
end

end


function B=shuffle_rows(A)
B=A;
n=size(A,2);
for i=1:size(A,1)
    B(i,:)=datasample(A(i,:),n,'Replace',false);
end
end


function C=cluster_data(C)
 N=histcounts(C,1:max(C)+1);
 b=1;
for i=1:size(N,2)
    if (N(i)==1)
    C(C==i)=0;
    else
     C(C==i)=b;
     b=b+1;
    end
        
end
end

    

