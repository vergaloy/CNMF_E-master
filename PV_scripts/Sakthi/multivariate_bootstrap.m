function out=multivariate_bootstrap(obj,replicates)
out(1:replicates,1:size(obj,2))=0;
for i=1:replicates
    y = datasample(obj,size(obj,1),1);%+random('HalfNormal',0,0.0001,size(obj,1),size(obj,2));
    out(i,:)=mean(y,1);
end
