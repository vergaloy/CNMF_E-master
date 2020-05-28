

for i=1:9
    temp=C{1,i};
    Diss(:,i)=convergance_performance_cluster_NMF(temp);
end