function [LDV,linear_comb,delete]=licols(X)

comb=makebits(size(X,2));
s=0;
ld=0;
for i=1:size(comb,2)
    for j=1:size(comb,1)
        if (comb(j,i)~=1)
            T=X.*comb(j,:);
            T=sum(T,2);
            T(T>0)=1;
            if (T==X(:,i))
                combinations=find(comb(j,:));
                for lo=1:length(combinations)
                    s=s+1;
                    delete(s)=i;
                    linear_comb(s,1:2)=[b2d(X(:,i)') b2d(X(:,combinations(lo))')];
                end
            end  
        end
    end
end
if(exist('linear_comb','var'))
LDV=unique(linear_comb(:,1));
delete=unique(delete);
else
    LDV=0;
    delete=0;
    linear_comb=0;
end


