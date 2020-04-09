function diff=Shepard_Plot(dissimilarities,distances,disparities,criteria,plo)


M={'stress','sstress'};
if (any(strcmp(M,criteria)))
    metric=0;
else
    metric=1;
end


if dissimilarities(1,1)==1  %% transform similarity matrix into dissimilarities
dissimilarities=sqrt(1-dissimilarities);
end

if (metric==0)
    dissimilarities=squareform(dissimilarities,'tovector')';
    distances = pdist(distances);
    disparities=squareform(disparities,'tovector')';
    [dum,ord] = sortrows([dissimilarities disparities]);
    
    for i=1:size(dum,1)
    diff(i)=pdist([dum(i,:);dissimilarities(ord(i)),distances(ord(i))]);
    end
    diff=(diff.^2)/sum(distances.^2);
    if (plo==1)
        figure;plot(dissimilarities,distances,'bo', ...
            dissimilarities(ord),disparities(ord),'r.-');
        xlabel('Dissimilarities')
        ylabel('Distances/Disparities')
        legend({'Distances' 'Disparities'}, 'Location','NorthWest');
    end
else
    
    dissimilarities=squareform(dissimilarities,'tovector');
    distances = pdist(distances);
    diff=abs(distances-dissimilarities);
    if (plo==1)
        figure;plot(dissimilarities,distances,'bo', [0 max(disparities(:))],[0 max(disparities(:))],'k--');
        xlabel('Dissimilarities')
        ylabel('Distances')
    end
    [R,P_val] = corr(dissimilarities',distances');
    
end