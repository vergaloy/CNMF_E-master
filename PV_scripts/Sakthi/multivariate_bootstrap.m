function out=multivariate_bootstrap(obj,replicates)
out(1:size(obj,1),1:replicates)=0;
for i=1:replicates
    y = datasample(obj,size(obj,2),2);
   out(:,i)=mean(y,2);%+randn(size(obj,1),1)/1000;
end
m=mean(out,2);
out=((out-m).*sqrt(size(obj,2)-1))+m;