function plot_cluster_heatmap2D(datain,Z1,L1,clus1,Z2,L2,clus2)
%  plot_cluster_heatmap2D(zscore(zscore(a)')',Z,L,clus,Z2,L2,clus2);
%% set widths of subplots
m = .1; % margin
ww = .2; % width of W plot
wwflat = .05; % width of Wflat plot
hh = .25; % height of H plot
hdata = 1-hh-2*m; 
wdata = 1-ww-wwflat-2*m; 
sep = ceil(5*.1); 

%% plot upper dendrogram
axH = subplot('Position', [m+ww m+hdata wdata hh]);

perm1 = order_tree(Z1);
C1=update_C(L1,clus1);
h1=dendrogram(Z1,0);
set(axH,'XTick',[], 'YTick', [])
color_tree(C1,h1);

%% plot left dendrogram
axW = subplot('Position', [m m ww hdata]);
perm2 = order_tree(Z2);
C2=update_C(L2,clus2);
h2=dendrogram(Z2,0,'Orientation','left');
set(axW,'XTick',[], 'YTick', [])
color_tree(C2,h2);

%% plot data
axIm = subplot('Position', [m+ww m wdata hdata]);
if (size(datain,2)==9)
values={'HC','preS','postS','REM','HT','LT','N','A','C'};
else
 values={'HC','preS','postS','A','C'};   
end
values=values(perm1);
cmap = money(datain, 256);
imagesc(datain(flip(perm2),perm1));
colormap('parula');
set(axIm,'ytick',[],'xtick',1:9,'xticklabel',values)
linkaxes([axIm axW], 'y'); linkaxes([axIm axH], 'x');
cb=colorbar('eastoutside');
set(cb,'Position',[0.87 m 0.03 hdata])
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

function cmap = money(data, clevels)
% Function to make the heatmap have the green, white and red effect
n = min(data(:));
x = max(data(:));
if x == n, x = n+1; end
zeroInd = round(-n/(x-n)*(clevels-1)+1);
if zeroInd <= 1 % Just green
    b = interp1([1 clevels], [1 0], 1:clevels);
    g = interp1([1 clevels], [1 1], 1:clevels);
    r = interp1([1 clevels], [1 0], 1:clevels);
elseif zeroInd >= clevels % Just red
    b = interp1([1 clevels], [0 1], 1:clevels);
    g = interp1([1 clevels], [0 1], 1:clevels);
    r = interp1([1 clevels], [1 1], 1:clevels);
else
    b = interp1([1 zeroInd clevels], [0 1 0], 1:clevels); 
    g = interp1([1 zeroInd clevels], [0 1 1], 1:clevels);
    r = interp1([1 zeroInd clevels], [1 1 0], 1:clevels);
end
cmap = [g' b' r'];
end
