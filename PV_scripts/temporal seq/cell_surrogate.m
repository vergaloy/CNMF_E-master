function sur=cell_surrogate(W)
% sur=cell_surrogate(Wall);
sur=W;
for i=1:size(W,1)
    n=size(W{i,1},1);
    ncol=randsample(n,n,'true');
    for j=1:size(W,2)
        sur{i,j}=W{i,j}(ncol,:);
    end
end
        
end