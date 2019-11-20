function [PVD,W_NMF,H_NMF]=PVD_matrix_PCA(obj,hypno)
%[matrix,W_NMF]=PVD_matrix(temp_bin,hypno)
obj=full(obj);
obj(obj>0)=1;
obj=moving_mean(obj,5.01,2,1/5.01,0);
obj=obj./rms(obj,2);

sf=5.01;

j=1;
A{j}=obj(:,1:round(sf*600));

[~,W_NMF{j},H_NMF{j},~,~]=functional_connectivty(A{j},A{j},5,1);
s=A{j};
y=sum(W_NMF{1, j},2);
A{1}=s(y>0,:);
figure
h1=subplot(2,1,1);
imagesc(A{j})
h1=subplot(2,1,2);
plot(H_NMF{1, j}')
xlim([0 length(A{j})])
ylim([0 0.15])
drawnow

j=2;
A{j}=obj(:,round(sf*600+1):round(sf*1200));

[~,W_NMF{j},H_NMF{j},~,~]=functional_connectivty(A{j},A{j},5,1);
s=A{j};
y=sum(W_NMF{1, j},2);
A{1}=s(y>0,:);
figure
h1=subplot(2,1,1);
imagesc(A{j})
h1=subplot(2,1,2);
plot(H_NMF{1, j}')
xlim([0 length(A{j})])
ylim([0 0.15])
drawnow

j=3;
A{j}=obj(:,round(sf*1200+1):round(sf*1500));

[~,W_NMF{j},H_NMF{j},~,~]=functional_connectivty(A{j},A{j},5,1);
s=A{j};
y=sum(W_NMF{1, j},2);
A{1}=s(y>0,:);
figure
h1=subplot(2,1,1);
imagesc(A{j})
h1=subplot(2,1,2);
plot(H_NMF{1, j}')
xlim([0 length(A{j})])
ylim([0 0.15])
drawnow


sleepdata=separate_by_sleep(obj(:,round(sf*1500+1):round(sf*10500)),hypno(round(sf*1500+1):round(sf*10500)));

j=4;
A{j}=sleepdata.wake;
[~,W_NMF{j},H_NMF{j},~,~]=functional_connectivty(A{j},A{j},5,1);
s=A{j};
y=sum(W_NMF{1, j},2);
A{1}=s(y>0,:);
figure
h1=subplot(2,1,1);
imagesc(A{j})
h1=subplot(2,1,2);
plot(H_NMF{1, j}')
xlim([0 length(A{j})])
ylim([0 0.15])
drawnow

j=5;
A{j}=sleepdata.rw;

[~,W_NMF{j},H_NMF{j},~,~]=functional_connectivty(A{j},A{j},5,1);
s=A{j};
y=sum(W_NMF{1, j},2);
A{1}=s(y>0,:);
figure
h1=subplot(2,1,1);
imagesc(A{j})
h1=subplot(2,1,2);
plot(H_NMF{1, j}')
xlim([0 length(A{j})])
ylim([0 0.15])
drawnow

j=6;
A{j}=sleepdata.rem;
[~,W_NMF{j},H_NMF{j},~,~]=functional_connectivty(A{j},A{j},5,1);
s=A{j};
y=sum(W_NMF{1, j},2);
A{1}=s(y>0,:);
figure
h1=subplot(2,1,1);
imagesc(A{j})
h1=subplot(2,1,2);
plot(H_NMF{1, j}')
xlim([0 length(A{j})])
ylim([0 0.15])
drawnow

j=7;
A{j}=sleepdata.nrem;
[~,W_NMF{j},H_NMF{j},~,~]=functional_connectivty(A{j},A{j},5,1);
s=A{j};
y=sum(W_NMF{1, j},2);
A{1}=s(y>0,:);
figure
h1=subplot(2,1,1);
imagesc(A{j})
h1=subplot(2,1,2);
plot(H_NMF{1, j}')
xlim([0 length(A{j})])
ylim([0 0.15])
drawnow

j=8;
A{j}=obj(:,round(sf*10500+1):round(sf*11100));
[~,W_NMF{j},H_NMF{j},~,~]=functional_connectivty(A{j},A{j},5,1);
s=A{j};
y=sum(W_NMF{1, j},2);
A{1}=s(y>0,:);
figure
h1=subplot(2,1,1);
imagesc(A{j})
h1=subplot(2,1,2);
plot(H_NMF{1, j}')
xlim([0 length(A{j})])
ylim([0 0.15])
drawnow

j=9;
A{j}=obj(:,round(sf*11100+1):round(sf*11700));
[~,W_NMF{j},H_NMF{j},~,~]=functional_connectivty(A{j},A{j},5,1);
s=A{j};
y=sum(W_NMF{1, j},2);
A{1}=s(y>0,:);
figure
h1=subplot(2,1,1);
imagesc(A{j})
h1=subplot(2,1,2);
plot(H_NMF{1, j}')
xlim([0 length(A{j})])
ylim([0 0.15])
drawnow

matrix(1:9,1:9)=0;
comb=nchoosek(1:9,2);

for i=1:size(comb,1)
    matrix(comb(i,1),comb(i,2))=PVD(A{comb(i,1)},A{comb(i,2)},size(A{comb(i,1)},1));
end
matrix=matrix+matrix';

figure
imagesc(matrix);


%colormap(jet)
    