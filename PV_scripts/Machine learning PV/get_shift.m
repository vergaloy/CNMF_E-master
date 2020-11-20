function D2=get_shift(ZI,ZJ,m)
% D2=get_shift(X(1,:),X(2:end,:),491);
% D2=get_shift(X2(1,:),X2(2:end,:),491);
for i=1:size(ZJ,1)     
    for k=-m:m
    temp=circshift(ZI,k,2);   
    d(k+m+1)=corr(temp',ZJ(i,:)');
    end
    [~,D2(i)]=max(d);    
end