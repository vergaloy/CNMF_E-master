
function [distance,P]=MRPP(X1,X2,sim);
%Multiple Response Permutation Procedures  distance=MRPP(X1,X2,10000);
%   rng('default') % For reproducibility
%   X1 = transpose(mvnrnd([0,0],[1 0;0 1],1000)); %create random multivariate data;
%   X2 = transpose(mvnrnd([0.5;0.5],[1 0;0 1],1000)); %create random multivariate data;
%sqrt(2)*erfcinv(0.5)



D=sqrt(sum((mean(X1,2)-mean(X2,2)).^2));
U=[X1,X2];
I(1:size(U,2))=0;

sur(1:sim)=0;
for i=1:sim
    R=randperm(size(U,2),size(X1,2));
    I(R)=1;
    X1s=U(:,logical(I));
    X2s=U(:,~logical(I));
    sur(i)=sqrt(sum((mean(X1s,2)-mean(X2s,2)).^2));
    I=0;
end
sur=sort(sur);
indx=find(sur>D,1);
if(~isempty(indx))
    P=(sim-indx+1)/(sim+1);  %(sim+1) is becuase of https://www.ncbi.nlm.nih.gov/pmc/articles/PMC379178/
else

    if (min(sur)>D)
     P=1;   
    else   
    
    dummy=2
    m=200;
    Xm1=sur(sim-m);
    HOS=log10(sur(sim-m+1:sim));     %highestorder statistics
    a=sum(HOS-log10(Xm1))/m;
    P=full((m/sim)*(D/Xm1)^(-1/a));
    if (P>1)
        dummy=1;
    end
    end
end
distance=sqrt(2)*erfcinv(P);

if (isinf(distance))
    dummy=1;
end


















