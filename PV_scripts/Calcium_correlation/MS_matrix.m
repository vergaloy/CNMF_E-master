function [MS]=MS_matrix(W,getMS)


MS(1:size(W,2),1:size(W,2))=0;
F(1:size(W,2),1:size(W,2))=0;
comb=nchoosek(1:size(W,2),2);

for i=1:size(comb,1)
  [MS(comb(i,1),comb(i,2))]=match_matrix(W{comb(i,1)},W{comb(i,2)},getMS);
end
MS=MS+MS';

if (getMS==1)
MS=MS+diag(ones(1,size(MS,1)));
end

