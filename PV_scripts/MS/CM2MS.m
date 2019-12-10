function MS=CM2MS(CM)

comb=nchoosek(1:size(CM,3),2);
MS(1:size(CM,3),1:size(CM,3))=0;
for i=1:size(comb,1)
    V1=CM(:,:,comb(i,1));
    Vt2=CM(:,:,comb(i,2));
    temp=nanmean(dot(V1,Vt2)./(sqrt(sum((V1).^2,1)).*sqrt(sum((Vt2).^2,1))));
    if (isnan(temp))
        temp=0;
    end
    MS(comb(i,1),comb(i,2))=temp;
end
MS=MS+MS';
MS(isnan(MS))=0;
MS = MS + diag(ones(1,size(MS,1)));