function [a,b]=corrmatrix(obj,kill_nans)
 
if (kill_nans==1)
s=sum(obj,1);
d=(s==0);
obj(:,d)=[];
end

a = corrcoef(obj);

b=nansum(a,1);
