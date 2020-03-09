function c=correlation_temporal_patterns(X,W);


w=size(W,3);
for i=1:size(W,2);
    Wt=squeeze(W(:,i,:));
    for s=1:size(X,2)-w
        c(i,s)=corr2(X(:,s:s+w-1),Wt);
    end
end



S=randsample(size(X,2),(1000+w)*size(X,1),true);
S=reshape(S,[size(X,1),1000+w]);
S=X(S);

for i=1:size(W,2);
    Wt=squeeze(W(:,i,:));
    for s=1:size(S,2)-w
        rc(i,s)=corr2(S(:,s:s+w-1),Wt);
    end
end
rc(isnan(rc))=0;
thr=prctile(rc,99,2);
c=c>thr;