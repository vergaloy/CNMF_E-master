function nzero=find_bin(obj)

for i=1:300
  temp=moving_mean(obj,10,i,1,0);  
  nzero(i)=nnz(~temp)/(size(temp,1)*size(temp,2)); 
end
