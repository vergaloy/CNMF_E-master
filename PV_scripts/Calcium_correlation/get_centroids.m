function [X]=get_centroids(obj1,obj2)
%[LD,LR]=get_centroids(neuron.Coor,sleepdata.bin.wake);
for i=1:size(obj1,1)
center(i,1:2)=mean(obj1{i, 1},2);
end

D = squareform(pdist(center));
[R] = corrcoef(transpose(obj2));

LD=squareform(D,'tovector');
LR=R-1;
LR=squareform(LR,'tovector');
LR=LR+1;
LD=LD';
LR=LR';
X(:,1)=LD;
X(:,2)=LR;

%scatter(LD,LR);

