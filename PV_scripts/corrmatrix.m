function [a,b]=corrmatrix(obj)
    
a = corrcoef(obj);

b=nansum(a,1);
