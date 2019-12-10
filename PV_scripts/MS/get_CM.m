function CM=get_CM(Wmatrix)
for i=1:size(Wmatrix,2)
    W=Wmatrix{1,i};
    temp=zeros(size(W,1));
    if(~isempty(W))
        for k=1:size(W,2)
            t=W(:,k);
            temp(:,:,k)=t*t';
        end
    end
    CM(:,:,i)=max(temp,[],3);
end
end