function W=get_pattern_cells_from_NMF(W,n)

for i=1:size(W,2)
    temp=W(:,i);
    temp2=temp;
    gm = fitgmdist(temp,2,'RegularizationValue',0.000001);
    idx = cluster(gm,temp);
    temp(idx==1)=0;
    temp2(idx==2)=0;
    if (max(temp)>max(temp2))
        W(:,i)=temp;
    else
        W(:,i)=temp2;
    end
end
del=W;
del(del>0)=1;
del=sum(del,1)-n+1;
del(del<=0)=0;
del=logical(del);
W=W(:,del);
end