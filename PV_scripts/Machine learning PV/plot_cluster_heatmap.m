function h=plot_cluster_heatmap(datain,Z,L,clus)
% plot_cluster_heatmap(datain,Z,L,clus);
perm = order_tree(Z);
C=update_C(L,clus);
t = tiledlayout(5,1,'TileSpacing','none','Padding','compact');
ax1 = nexttile;
h=dendrogram(Z,0);
set(ax1,'XTick',[], 'YTick', [])
color_tree(C,h);
ax2 = nexttile([4 1]);
h=plot_heatmap_PV(datain(perm,perm),'colormap',create_bicolor_map([1,1,1],[1,0,0]),'GridLines','none');
% values={'HC','preS','postS','REM','HT','LT','N','A','C'};
% values=values(perm);
% h=plot_heatmap_PV(datain(perm,perm),'colormap','parula','GridLines','-','x_labels',values,'y_labels',values);

linkaxes([ax1,ax2],'x');
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
colors = distinguishable_colors(length(N),[1 1 1; 0 0 0]);
for i=1:length(N)
    set( h(C==N(i)), 'Color', colors(i,:));
end
end
