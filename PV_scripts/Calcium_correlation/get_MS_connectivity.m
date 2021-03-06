function [MS]=get_MS_connectivity(Wmatrix)
%[MS]=get_MS_connectivity(W_NMF)
for i=1:size(Wmatrix,2)
    W=Wmatrix{1,i};
    temp=zeros(size(W,1));
    if(~isempty(W))
        for k=1:size(W,2)
            t=W(:,k);
            temp(:,:,k)=t*t';
        end
    end
    Ident{i}=max(temp,[],3);
end

comb=nchoosek(1:size(Ident,2),2);
MS(1:size(Ident,2),1:size(Ident,2))=0;
for i=1:size(comb,1)
    V1=Ident{comb(i,1)};
    Vt2=Ident{comb(i,2)};
    temp=nanmean(dot(V1,Vt2)./(sqrt(sum((V1).^2,1)).*sqrt(sum((Vt2).^2,1))));
    if (isnan(temp))
        temp=0;
    end
    MS(comb(i,1),comb(i,2))=temp;
end
MS=MS+MS';
MS(isnan(MS))=0;
MS = MS + diag(ones(1,size(MS,1)));
figure
imagesc(MS);

MS=sqrt(1-MS);
dims=2;
[Y,eigvals]=cmdscale(MS);
B = cumsum(eigvals);
B=B/B(end)*100;
B
%Dtriu =MS(find(tril(ones(size(MS,1)),-1)));
%Map_distance=squareform(pdist2(Y(:,1:dims),Y(:,1:dims)),'tovector')';
%maxrelerr = 100*(max(abs(Dtriu-Map_distance))./max(Dtriu))

conditions={'A','Post Shock','Retrival','C'};
figure
plot(Y(:,1),Y(:,2),'ro', 'MarkerSize',10);
text(Y(:,1)+0.02,Y(:,2)+0.005,conditions);
 
