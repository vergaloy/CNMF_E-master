function plot_heatmap_PV(C,B,values,tit,map)


C=C*100;
Tex=B<0.05;
Tex=num2cell(Tex);
Tex(B<0.001)={'***'};
Tex(B>0.001 & B<0.01)={'**'};
Tex(B>0.01 & B<0.05)={'*'};
Tex(B>=0.05)={''};
figure
heatmap_PV(C, values', values, Tex,'Colormap',map,'ShowAllTicks',1,'FontSize',12,'GridLines','-');
c=colorbar;

c.Ruler.TickLabelFormat='%g%%';

title(tit);
set(gcf, 'Position',  [700, 350, 700, 500])