function D2=cross_cosine_dist(ZI,ZJ,m)
% D2=cross_cosine_dist(b(1,:),b(2:25,:),1);
for i=1:size(ZJ,1)     
    for k=-m:m
    temp=circshift(ZI,k,2);        
    d(k+m+1)=dot(temp,ZJ(i,:))/(norm(temp)*norm(ZJ(i,:))); 
    end
    D2(i)=1-max(d);    
end