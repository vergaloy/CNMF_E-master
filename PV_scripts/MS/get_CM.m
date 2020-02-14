function CM=get_CM(W)

b = nchoosek(1:size(W,2),2);
CM(1:size(W,2),1:size(W,2))=0;
for i=1:b
   CM(b(i,1),b(i,2))= mean(pdist2(W{b(i,1)},W{b(i,2)},'mahalanobis'),'all');  
end
CM=CM+CM';
end