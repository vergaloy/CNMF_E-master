function hist_corr=hist_corr_distance(dist,corrw,lim,inter)

[dist,I] = sort(dist);
corrw=corrw(I);

hist_corr(1:floor(lim/inter),3)=0;
for i=1:floor(lim/inter)
  i1=(i-1)*inter;
  i2=i*inter;
    

idx1 = find(dist>i1,1,'first');
idx2 = find(dist<i2,1,'last');
hist_corr(i,1)=mean(corrw(idx1:idx2));
hist_corr(i,2)=std(corrw(idx1:idx2));
hist_corr(i,3)=length(corrw(idx1:idx2));
end

end