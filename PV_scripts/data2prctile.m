function p=data2prctile(X)
% t1=data2prctile(test);

for i=1:100
    p(i)=prctile(X,i); 
end
p=p';