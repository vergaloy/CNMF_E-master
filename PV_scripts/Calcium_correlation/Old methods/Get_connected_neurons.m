function [E,Out,P,pattern,C_cor,C_sum,C_shift,W,H,Out_clean]=Get_connected_neurons(X,min_nei,win,norm,correct_mc)
%[E,out,~,pattern,C_cor,C_sum,C_shift,W,H,Out_clean]=Get_connected_neurons(sleepdata.mean.wake,5,30,1,0);

[F,C_cor,C_sum,C_shift]=Functional_conec(X,win,norm,correct_mc);


P=F;
P=P+P';
F=graph(P);
Node=F.Edges.EndNodes;
timing(size(Node,1))=0;
ii=1;
for i=1:size(Node,1)
    if  (C_shift(Node(i,1),Node(i,2))<0)
        Node(i,:)=flip(Node(i,:));
    end
    if (C_shift(Node(i,1),Node(i,2))==0)
        zn(ii,:)=flip(Node(i,:));
        ii=ii+1;
    end
    timing(i)=C_shift(Node(i,1),Node(i,2));
end
if (ii>1)
Node=[Node;zn];
end
F=digraph(Node(:,1),Node(:,2),ones(1,size(Node,1)),size(F.Nodes,1));






disp('Grouping neurons in common ensambles...')
[bins,bsize] = conncomp(F);
bsize(bsize<min_nei)=[];
pattern(1:size(bins,2),1:size(bsize))=0;
for i=1:size(bsize,2)
pattern(:,i)=ismember(bins,bsize(i));
end


[Out,~,W,H,Out_clean]=sort_cells(X,pattern,C_shift);
figure
imagesc(Out);
figure
imagesc(Out_clean);

