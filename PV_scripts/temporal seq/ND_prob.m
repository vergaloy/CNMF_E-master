function A=ND_prob(A,order)


A=squeeze(sum(A,1)); 
Di=N_D_diag(A)';  

ind = find(A);


if (order==2)
[I(:,1),I(:,2)] = ind2sub(size(A), ind);
for i=1:size(I,1)
    su=Di(I(i,1))+Di(I(i,2));
    A(I(i,1),I(i,2))=A(I(i,1),I(i,2))/(su-A(I(i,1),I(i,2))*(order-1));  
end

A = A - diag(diag(A));
A(A==0)=nan;
end

if (order==3)
[I(:,1),I(:,2),I(:,3)] = ind2sub(size(A), ind);
for i=1:size(I,1)
    su=Di(I(i,1))+Di(I(i,2))+Di(I(i,3));
    A(I(i,1),I(i,2),I(i,3))=A(I(i,1),I(i,2),I(i,3))/(su-A(I(i,1),I(i,2),I(i,3))*(order-1));
end
end

if (order>3)
   
    display('The function need to be implemented for Dim>3!!!')
    
   return
end

dummy=1;



