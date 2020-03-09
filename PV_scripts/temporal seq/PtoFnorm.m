function F=PtoFnorm(P,dim_reduce);

if (dim_reduce~=0)
    for i=1:size(P,3)
        [S,V,D]=svd(P(:,:,i));
        V(dim_reduce+1:size(V,1),:)=0;
        A=S*V*D';
        temp(:,:,i)=A;
    end
 P=temp;   
end

b= nchoosek(1:size(P,3),2);
F=zeros(size(P,3),size(P,3));
for i=1:size(b,1)
    A=P(:,:,b(i,1));
    B=P(:,:,b(i,2));
    F(b(i,1),b(i,2))=F_norm(A,B);
end
F=F+F';
end




function f=F_norm(A,B)
f=sqrt(trace((A-B)*(A-B)'));
end