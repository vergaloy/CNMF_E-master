function out=multivariate_bootstrap(obj,replicates)
out(1:replicates,1:size(obj,2))=0;
obj(obj==0)=nan;

for i=1:replicates
    y = datasample(obj,size(obj,1),1);%+random('Normal',0,0.0001,size(obj,1),size(obj,2));
    out(i,:)=nanmean(y,1);
end
% n=sqrt(size(obj,1));
% m=mean(out,1);
% out=out-m;
% out=(out*n)+m;
