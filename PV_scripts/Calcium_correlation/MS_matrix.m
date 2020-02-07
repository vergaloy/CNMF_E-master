function MS=MS_matrix(W)

MS(1:size(W,2),1:size(W,2))=0;
comb=nchoosek(1:size(W,2),2);

for i=1:size(comb,1)
    MS(comb(i,1),comb(i,2))=get_MS(W{comb(i,1)},W{comb(i,2)});
end
MS=MS+MS';
MS(isnan(MS))=0;
MS = MS + diag(ones(1,size(MS,1)));
figure
imagesc(MS);

Y=cmdscale(1-MS);
conditions={'A','Post Shock','Retrival','C'};
figure
plot(Y(:,1),Y(:,2),'ro', 'MarkerSize',10);
text(Y(:,1),Y(:,2),conditions);
xlim([-0.6 0.8]) 
ylim([-0.6 0.8]) 


