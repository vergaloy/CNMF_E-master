function R=patter_corr(obj)

R=corrcoef(obj);
if (isnan(R))
 R=nan;
 return
end    
R=R-1;
R=squareform(R,'tovector');
R=R+1;
R=mean(R,2);