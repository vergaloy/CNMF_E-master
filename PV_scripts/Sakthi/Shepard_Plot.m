function Shepard_Plot(dissimilarities,distances,disparities,metric)

if (metric==0)
dissimilarities=squareform(dissimilarities,'tovector')';
distances = pdist(distances);
disparities=squareform(disparities,'tovector')';

[dum,ord] = sortrows([disparities dissimilarities]);
plot(dissimilarities,distances,'bo', ...
     dissimilarities(ord),disparities(ord),'r.-');
 xlabel('Dissimilarities')
ylabel('Distances/Disparities')
legend({'Distances' 'Disparities'}, 'Location','NorthWest');    
else
  
dissimilarities=squareform(dissimilarities,'tovector');
distances = pdist(distances);
plot(dissimilarities,distances,'bo', [0 ceil(max(disparities(:)))],[0 ceil(max(disparities(:)))],'k--');
xlabel('Dissimilarities')
ylabel('Distances')
  
[R,P_val] = corr(dissimilarities',distances')

end