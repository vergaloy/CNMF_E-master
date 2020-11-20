function h=plot_cluster_heatmap_means(HM,Z,L,clus)
% plot_cluster_heatmap_means(HM,Z,L,clus);
perm = order_tree(Z);
C=update_C(L,clus);
figure
t = tiledlayout(5,1,'TileSpacing','none','Padding','compact');
ax1 = nexttile;
h=dendrogram(Z,0);
set(h,'LineWidth',2)
set(ax1,'XTick',[], 'YTick', [])
color_tree(C,h);

ax2 = nexttile([4 1]);
if (size(HM,2)==9)
values={'HC','preS','postS','REM','HT','LT','N','A','C'};
else
 values={'HC','preS','postS','A','C'};   
end
values=values(perm);
imagesc(HM(perm,perm));
colormap('parula');
set(ax2,'xtick',1:9,'xticklabel',values,'yticklabel',values)
linkaxes([ax1,ax2],'x');
cb=colorbar('eastoutside');
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
