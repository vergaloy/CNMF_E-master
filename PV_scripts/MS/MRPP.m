
function distance=MRPP(X1,X2,sim)  
%Multiple Response Permutation Procedures
%   rng('default') % For reproducibility
%   X1 = transpose(mvnrnd([0,0],[1 0;0 1],1000)); %create random multivariate data;
%   X2 = transpose(mvnrnd([0.08;0.08],[1 0;0 1],1000)); %create random multivariate data;
%sqrt(2)*erfcinv(0.5)



D=sqrt(sum((mean(X1,2)-mean(X2,2)).^2));
U=[X1,X2];


sur(1:sim)=0;
for i=1:sim
    X1s=U(:,randperm(size(U,2),size(X1,2)));
    X2s=U(:,randperm(size(U,2),size(X2,2)));
    sur(i)=sqrt(sum((mean(X1s,2)-mean(X2s,2)).^2));
end
sur=sort(sur);
indx=find(sur>D,1);
if(~isempty(indx))
P=(sim-indx+1)/(sim+1);  %(sim+1) is becuase of https://www.ncbi.nlm.nih.gov/pmc/articles/PMC379178/
else
%P-value is to small, pareto statistics will be used instead 
%REF: https://keppel.qimr.edu.au/staff/davidD/Sib-pair/Documents/extrapolatedMCPvalues2011.pdf    
m=20;
Xm1=sur(sim-m);
HOS=log10(sur(sim-m+1:sim));     %highestorder statistics
a=sum(HOS-log10(Xm1))/m;
P=full((m/sim)*(D/Xm1)^(-1/a));
if (iszero(P))   
    dummy=1;
end

end



distance=sqrt(2)*erfcinv(P);

if (isinf(distance))   
    dummy=1;
end





    












