function [F,T,Node2,E,pattern]=Node_neighbors(F,min_nei)
%Find cells with common connections
loop_stop=0;
while (loop_stop==0)
    Node(1:size(F.Nodes,1),1:size(F.Nodes,1))=0;
    for i=1:size(F.Nodes,1)
        Node(i,[neighbors(F,i);i])=1;
    end
    neig(1:size(F.Nodes,1),1:size(F.Nodes,1))=0;
    for i=1:size(F.Nodes,1)
        for j=1:size(F.Nodes,1)
            if (dot(Node(i,:),Node(j,:))>=min_nei)
                neig(i,j)=1;
            else
                neig(i,j)=0;
            end
        end
    end
    F=simplify(graph(neig));
    
    Node2(1:size(F.Nodes,1),1:size(F.Nodes,1))=0;
    for i=1:size(F.Nodes,1)
        Node2(i,[neighbors(F,i);i])=1;
    end
    
    if (corr2(Node,Node2)==1)
        loop_stop=1;
    end
end
T=sum(Node2,2);
T(T==1)=0;
T(T>0)=1;
ensamble(1:size(F.Nodes,1),1:size(F.Nodes,1))=0;
%% Group cells in ensambles, store each ensamble in a binary value.
for i=1:size(F.Nodes,1)
    for j=1:size(F.Nodes,1)
        if (i==j)
            ensamble(i,j)=0;
        else
            if(Node2(i,j)==0)
                ensamble(i,j)=0;
            else
                ensamble(i,j)=b2d((Node2(:,i).*Node2(:,j))');
            end
        end
    end  
   
end
%% check wich patterns are linear combinations of others. 
V=squareform(ensamble,'tovector'); 
U=unique(V);
U(U==0)=[];
n_nue=size(ensamble,1);
pattern(1:n_nue,1:length(U))=0;
for i=1:length(U) %convert patterns from decimal to binary
    temp=d2b(U(i));
    pattern(:,i)=[zeros(1,n_nue-length(temp)),temp]';
end

[LDV,combinations,delete]=licols(pattern);  %get linearly-dependent vectors



E=ensamble;
E(ismember(ensamble,LDV))=0;
E=graph(E);
if (LDV~=0)
    pattern(:,delete)=[];
    for i=1:size(ensamble,1)
        if (any(ismember(LDV,ensamble(:,i))))
            for j=1:size(ensamble,1)
                if (ismember(ensamble(i,j),LDV))
                    ensamble(j,i)=0;
                    edg=find(combinations(:,1)==ensamble(i,j));
                    for r=1:length(edg)
                        E = addedge(E,i,j,combinations(edg(r),2));
                    end
                end
            end
        end
    end
end
dummy=1;






