function C=cross_corr_distance(x1,x2)
for i=1:size(x2,1)
    temp=1-max(xcov(x1,x2(i,:),2,'coeff'));
    temp(isnan(temp))=0;
    C(i)=temp;
end
end