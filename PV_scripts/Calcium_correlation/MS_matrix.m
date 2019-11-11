function matrix=MS_matrix(obj)

matrix(1:size(obj,2),1:size(obj,2))=0;
comb=nchoosek(1:size(obj,2),2);

for i=1:size(comb,1)
    matrix(comb(i,1),comb(i,2))=get_MS(obj{comb(i,1)},obj{comb(i,2)});
end
matrix=matrix+matrix';
matrix = matrix + diag(ones(1,size(matrix,1)));

imagesc(matrix);


