function [E,Out,P,pattern,C_cor,C_sum,C_shift]=Find_correlated_cells(X,min_nei,win,norm)
%[E,Out,P,pattern,C_cor,C_sum,C_shift]=Find_correlated_cells(sleepdata.mean.wake,3,600,0)

[F,C_cor,C_sum,C_shift]=Functional_conec(X,win,norm);
P=F;
F=graph(F,'upper');
disp('Grouping neurons in common ensambles...')
[~,~,~,E,pattern]=Node_neighbors(F,min_nei);
figure
h=plot(E);
h.NodeColor = 'k';
h.LineWidth=2;
Edges=table2array(E.Edges(:,2));
Edges_num=unique(Edges);
L(1:length(Edges_num),1:size(E.Edges,1))=0;
L=logical(L)';
colors = distinguishable_colors(length(Edges_num));
for i=1:length(Edges_num)     
        L(Edges_num(i)==Edges(:),i)=1;   
        highlight(h,'Edges',L(:,i),'EdgeColor',colors(i,:));
end
[Out,~]=sort_cells(X,pattern,C_shift);
figure
imagesc(Out);

