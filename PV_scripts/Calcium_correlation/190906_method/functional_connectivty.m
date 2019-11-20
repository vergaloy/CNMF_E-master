function [E,W,H,patterns,pat_cells]=functional_connectivty(ref,obj,minsize,plotme)
%[E,W,H,patterns,Ordered]=functional_connectivty(neuron.S,neuron.S,3);
disp('Getting ensambles of neurons...      ')
output_args = findICAAssemblies((ref'),0.1);

% Clean small patterns and sort others in decreasing order
patterns=output_args.cs_assemblies;
patternsize(size(patterns,1))=0;
for i=1:size(patterns,1)
    patternsize(i)=size(patterns{i, 1},1);
end
[~,I]=sort(patternsize,'descend');
patterns=patterns(I);
patternsize=patternsize(I);
patterns(patternsize(:)<minsize)=[];

% Find patterns activity through NMF
fprintf('\n ');
disp('Running NMF...      ')
%Ordered=[];
W(1:size(obj,1),1:size(patterns,1))=0;
H(1:size(patterns,1),1:size(obj,2))=0;
for i=1:size(patterns,1)
    fprintf('.')
    temp=obj(patterns{i, 1},:);
    %Ordered=[Ordered;temp];
    [Wt,Ht,~]=NMF(temp,1);
    W(patterns{i, 1},i)=Wt;
    H(i,:)=Ht;
end

%Creating graph with patterns
F(1:size(obj,1),1:size(obj,1))=0;
for i=1:size(patterns,1)
    pat=patterns{i, 1};
    for ii=1:size(pat,1)
        for jj=1:size(pat,1)
            F(pat(ii),pat(jj))=1;
        end
    end
end
E=graph(F);
E = simplify(E);
if (plotme==1)
    figure
    h=plot(E);
    h.NodeColor = 'k';
    h.LineWidth=2;
    colors = distinguishable_colors(length(patterns));
    for i=1:length(patterns)
        light(1:size(E.Edges,1),1)=0;
        light(ismember(E.Edges.EndNodes(:,1),patterns{i, 1})&ismember(E.Edges.EndNodes(:,2),patterns{i, 1}))=1;
        highlight(h,'Edges',logical(light(:,1))','EdgeColor',colors(i,:));
    end
end


pat_cells=W;
pat_cells=sum(pat_cells,2);
pat_cells(pat_cells>0)=1;
pat_cells=logical(pat_cells);


end


