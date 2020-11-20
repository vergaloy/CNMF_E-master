function [S,av]=get_significant_weights(W)
% [S,av]=get_significant_weights(out{2,1});
b=nchoosek(1:size(W,1),2);
S=false(size(W,3),size(b,1));

for i=1:size(b,1)
    temp=squeeze(W(b(i,1),b(i,2),:,:));
%     av(:,i)=mean(temp,2);
    m=(nanmean(temp,2))./nanstd(temp,[],2);
    av(:,i)=m;
    m=normcdf(abs(m),'upper'); 
    m(isnan(m))=0.5;
    S(:,i)=logical(fdr_bh(m));
end

av(isnan(av))=0;




