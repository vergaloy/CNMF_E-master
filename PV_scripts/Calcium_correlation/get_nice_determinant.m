function d=get_nice_determinant(S,dim)

[U,D,V] = svd(S);
I=sum(D,2);
I=I./max(I,[],'all');
I(1:size(S,1))=0;
I(1:dim)=1;
I=logical(I);
U2=U(I,I);
D2=D(I,I);
V2=V(I,I);

S2=U2*D2*V2';
d=det(S2);

