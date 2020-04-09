function Yout=align_to_mean(Y)

M=mean(Y,3);

for i=1:size(Y,3)
    temp=Y(:,:,i);
    Yout(:,:,i)=align_matrix(M,temp);
end