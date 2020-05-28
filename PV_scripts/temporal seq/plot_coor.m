function plot_coor(obj,new_figure)
% plot_coor(neuron,1);
[d1,d2]=size(obj.Cn);
 coor = get_contours(obj, 0.6);
if (new_figure)
    figure
    xlim([0 d2])
    ylim([0 d1])
end

hold on
for i=1:size(coor,1)
 test=coor{i, 1};     
 plot(test(1,:),test(2,:),'LineWidth',2,'Color','b');   
end

set(gca, 'YDir','reverse')