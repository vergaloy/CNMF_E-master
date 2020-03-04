function [MS]=get_MS(A,B)
sur(1:1000)=0;
for i=1:size(A,2)
    v1=A(:,i);
    v2=B(:,i);
    MS=MSget(v1,v2);
    for s=1:1000
        v1s=v1(randperm(size(v1,1)));
        v2s=v2(randperm(size(v2,1)));
        sur(s)=MSget(v1s,v2s);
    end
    try
    P(i)=get_P(MS,sur);
    catch
        dummy=1;
    end
end
[ind,thr] = FDR(P,0.05);
MS=length(ind)/size(A,2);
end
function MS=MSget(v1,v2)
MS=nanmean(dot(v1,v2)./(sqrt(sum((v1).^2,1)).*sqrt(sum((v2).^2,1))));
end
