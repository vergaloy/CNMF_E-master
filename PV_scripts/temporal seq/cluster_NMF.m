function [W,H]=cluster_NMF(C,exclud,showplot)
% [W,H]=cluster_NMF(C,[],1);

X=[];
t=0;
for i=1:size(C,2)
    if (~ismember(i,exclud))
        X=[X,full(C{1,i})];
        t=t+1;
        siz(t)=size(C{1,i},2);
    end
end

Clust=cluster_neurons(X,showplot); 
[W,H]=get_cluster_activity_by_NMF(X,Clust,showplot);

t=0;
for i=1:size(siz,2)
    t=t+siz(i);
    le(i)=t;
    xline(t);
end
  hm=get_pattern_activity(X,H,le);
end

