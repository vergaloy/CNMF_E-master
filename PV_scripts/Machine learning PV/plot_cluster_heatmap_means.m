function h=plot_cluster_heatmap_means(HM,Z,L,clus)
% plot_cluster_heatmap_means(HM,Z,L,clus);
perm = order_tree(Z);
C=update_C(L,clus);
figure
t = tiledlayout(5,1,'TileSpacing','none','Padding','compact');
ax1 = nexttile;
  h=dendrogram(Z,0);
%  h=dendrogram(Z,0,'Reorder',[1,2,3,4]);
%  perm=[1,2,3,4];
set(h,'LineWidth',2)
set(ax1,'XTick',[], 'YTick', [])
color_tree(C,h);

ax2 = nexttile([4 1]);
if (size(HM,2)==9)
values={'HC','preS','postS','REM','HT','LT','N','A','C'};
elseif (size(HM,2)==8)
values={'HC','preS','postS','REM','HT','LT','N','A'}; 
elseif (size(HM,2)==15)
   values={'HC','preS','postS','1','2','3','4','5','6','7','8','9','10','Test','New'};  
   elseif (size(HM,2)==4)
  values={'HC','preS','postS','Test'}; 
else
 values={'HC','preS','postS','Test','New'};   
end
  values=values(perm);

ax1=plot_heatmap_PV(HM(perm,perm),'colormap','parula','GridLines','-','x_labels',values,'y_labels',values);
% imagesc(HM(perm,perm));
% colormap('parula');
% set(ax2,'xtick',1:size(HM,1),'ytick',1:size(HM,2),'xticklabel',values,'yticklabel',values)
linkaxes([ax1,ax2],'x');
% cb=colorbar('eastoutside');
end


function C=update_C(L,clus)
C=zeros(1,size(L,1));
for i=1:size(clus,1)
    for j=1:size(L,1)
        if (prod(ismember(sort(L{j, 1}),sort(clus{i, 1})))>0)
            C(j)=i;
        end
    end
end
end

function color_tree(C,h)
set( h(1:length(h)), 'Color', 'k' );
N=unique(C);
N=N(2:end);
colors = distinguishable_colors(length(N));
for i=1:length(N)
    set( h(C==N(i)), 'Color', colors(i,:));
end
end
