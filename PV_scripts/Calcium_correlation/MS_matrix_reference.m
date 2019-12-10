function MS=MS_matrix_reference(W,V1)  %V1 is the reference
for i=1:size(W,2)
    V2=W{1,i};
    if(size(V1,2)>size(V2,2))
        new = zeros(size(V1));
        new(1:size(V2,1),1:size(V2,2)) = V2;
        V2=new;
    end
    b = nchoosek(1:size(V2,2),size(V1,2));
    for k=1:size(b,1)
        Vt2=V2(:,b(k,:));
             MSs(k)=nanmean(dot(V1,Vt2)./(sqrt(sum((V1).^2,1)).*sqrt(sum((Vt2).^2,1))));
    end 
    [~,I]=sort(MSs,'descend');
    W2{i}=V2(:,b(I(1),:));
    MSs=[];
    I=[];
end
    
 MS=MS_matrix(W2) ;  

