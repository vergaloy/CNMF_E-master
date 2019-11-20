function PVD=PVD_matrix(A)

t=size(A,1);
PVD(1:t,1:t)=0;
comb=nchoosek(1:9,2);

for i=1:size(comb,1)
    PVD(comb(i,1),comb(i,2))=PVD(A{comb(i,1)},A{comb(i,2)},size(A{comb(i,1)},1));
end
PVD=PVD+PVD';

figure
imagesc(PVD);


%colormap(jet)