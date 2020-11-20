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