function T=CtoT(C);
T=[];
for i=1:size(C,2)
    for n=1:size(C{1,i},1)
     tn=C{1,i}(n,:);
     nf(n)=mean(tn(tn>0));
    end
    
    
    S=C{1,i}./nf';
    S(isnan(S))=0;
    T=[T,S];
end