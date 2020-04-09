function MS=multiple_pattern_MS(W)
% MS=multiple_pattern_MS(Wall)
dim=size(W,2);
mouses=size(W,1);
b=nchoosek(1:dim,2);
MS=zeros(dim,dim);
for i=1:length(b)
    x1=b(i,1);
    x2=b(i,2);   
    for m=1:mouses
    [~,v1{m},v2{m}]=W_SM(W{m,x1},W{m,x2});
    end 
    pat_MS=cell2mat(v1);
    weig=cell2mat(v2);
    MS(x1,x2)=sum(pat_MS.*(weig/sum(weig)));    
end
MS=(MS+MS')+diag(ones(1,dim));
MS=acos(MS)/pi;
end



