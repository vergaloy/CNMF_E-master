function [BP,Z,L]=hierarchical_cluster_bootstrap(data,rep,C_method,sim,C_dist,m)

% dist = squareform(pdist(data,'euclidean'));
Z = linkage(data,C_method,{C_dist,m});
L=find_leaves_in_node(Z);

S(size(Z,1),sim)=0;
bin=0;
data2=data;

if (isa(C_dist,'function_handle'))
    if (strcmp(func2str(C_dist),'cross_cosine_dist'))
        bin=m;
        data2=[data(:,size(data,2)-bin+1:size(data,2)),data,data(:,bin)];
    end
end


parfor s=1:sim
warning off
temp=sample_from_data(data2,rep,bin);
% temp_dist = squareform(pdist(temp,'euclidean'));
Z_temp = linkage(temp,C_method,{C_dist,m});
L_temp=find_leaves_in_node(Z_temp);
S(:,s)=cell_is_member(L,L_temp);
end
BP=1-mean(S,2);

end


function L=find_leaves_in_node(Z)
M=size(Z,1)+1;
L = num2cell(Z(:,1:2),2);
for i=1:size(Z,1)
    temp=L{i, 1};
    while (ismember(1,temp>M))
        f=find(temp>M,1);
        k=temp(f);
        temp(f)=[];
        temp=[temp,L{k-M, 1}];
    end
    L{i, 1}=temp;
end
end

function out=cell_is_member(A,B)
out=zeros(size(A,1),1);
for i=1:size(A,1)
    temp=A{i, 1};
    r=0;
    for j=1:size(B,1)
        if (isequal(sort(temp),sort(B{j, 1})))
            r=1;
            break
        end
    end
    out(i)=r;
end

end


    
    