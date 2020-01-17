function B=Shuffle(A)

% Original matrix
[M,N] = size(A);
% Preserve the  indices
rowIndex = repmat((1:M)',[1 N]);
% Get randomized column indices by sorting a second random array
[~,randomizedColIndex] = sort(rand(M,N),2);
% Need to use linear indexing to create B
newLinearIndex = sub2ind([M,N],rowIndex,randomizedColIndex);
B = A(newLinearIndex);