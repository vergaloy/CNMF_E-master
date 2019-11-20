function pat_cells=plot_W_connectivity(W)

patterns{1}=0;
F(1:size(W,1),1:size(W,1))=0;
for i=1:size(W,2)
    pat=find(W(:,i)>0);
    patterns{i}=find(W(:,i)>0);
    for ii=1:size(pat,1)
        for jj=1:size(pat,1)
            F(pat(ii),pat(jj))=1;
        end
    end
end
E=graph(F);
E = simplify(E);
    figure
    h=plot(E);
    h.NodeColor = 'k';
    h.LineWidth=2;  
    colors = distinguishable_colors(length(patterns));
    for i=1:length(patterns)
        light(1:size(E.Edges,1),1)=0;
        light(ismember(E.Edges.EndNodes(:,1),patterns{1, i})&ismember(E.Edges.EndNodes(:,2),patterns{1, i}))=1;
        highlight(h,'Edges',logical(light(:,1))','EdgeColor',colors(i,:));
    end



pat_cells=W;
pat_cells=sum(pat_cells,2);
pat_cells(pat_cells>0)=1;
pat_cells=logical(pat_cells);


end