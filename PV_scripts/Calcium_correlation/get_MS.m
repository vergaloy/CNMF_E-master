function [dot_matrix,MS]=get_MS(V1,V2)

dot_matrix(1:size(V1,2),1:size(V2,2))=0;

for i=1:size(V1,2)
    for j=1:size(V2,2)
        dot_matrix(i,j)=dot(V1(:,i),V2(:,j))/(norm(V1(:,i))*norm(V2(:,j)));
    end
end

MS=mean(sum(dot_matrix,1),2);

end
