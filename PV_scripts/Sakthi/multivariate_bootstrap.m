function out=multivariate_bootstrap(in,replicates)
out(1:size(in,1),1:replicates)=0;
for i=1:replicates
    y = datasample(1:size(in,2),size(in,2));
   out(:,i)=mean(in(:,y),2)+randn(size(in,1),1)/100;
end
m=mean(out,2);
out=((out-m).*sqrt(size(in,2)-1))+m;