function [PVD,W_NMF,H_NMF]=PVD_matrix_akaike(obj,hypno)
%[matrix,W_NMF]=PVD_matrix(temp_bin,hypno)
obj=full(obj);
obj(obj>0)=1;
obj=moving_mean(obj,5.01,2,1/5.01,0);
obj=obj./rms(obj,2);

sf=5.01;
A{1}=obj(:,1:round(sf*600));


[W_NMF{1},H_NMF{1},~]=NMF_Akaike(A{1});


figure
h1=subplot(2,1,1);
imagesc(A{1})
h1=subplot(2,1,2);
plot(H_NMF{1, 1}')
xlim([0 length(H_NMF{1, 1})])
ylim([0 0.15])
drawnow

A{2}=obj(:,round(sf*600+1):round(sf*1200));
NumberOfAssemblies= get_patterns(A{2});

if (NumberOfAssemblies~=0)
    [W_NMF{2},H_NMF{2},~]=NMF(A{2},NumberOfAssemblies);
else
    W_NMF{2}=0;
    H_NMF{2}=0;
end

figure
h1=subplot(2,1,1);
imagesc(A{2})
h1=subplot(2,1,2);
plot(H_NMF{1, 2}')
xlim([0 length(H_NMF{1, 2})])
ylim([0 0.15])
drawnow

A{3}=obj(:,round(sf*1200+1):round(sf*1500));
NumberOfAssemblies= get_patterns(A{3});
if (NumberOfAssemblies~=0)
[W_NMF{3},H_NMF{3},~]=NMF(A{3},NumberOfAssemblies);
else
    W_NMF{3}=0;
    H_NMF{3}=0;
end

figure
h1=subplot(2,1,1);
imagesc(A{3})
h1=subplot(2,1,2);
plot(H_NMF{1, 3}')
xlim([0 length(H_NMF{1, 3})])
ylim([0 0.15])
drawnow
sleepdata=separate_by_sleep(obj(:,round(sf*1500+1):round(sf*10500)),hypno(round(sf*1500+1):round(sf*10500)));

A{4}=sleepdata.wake;
NumberOfAssemblies= get_patterns(A{4});
if (NumberOfAssemblies~=0)
[W_NMF{4},H_NMF{4},~]=NMF(A{4},NumberOfAssemblies);
%[~,W{4},~,~,~]=functional_connectivty(A{4},A{4},3,0);
else
    W_NMF{4}=0;
    H_NMF{4}=0;
end
figure
h1=subplot(2,1,1);
imagesc(A{4})
h1=subplot(2,1,2);
plot(H_NMF{1, 4}')
xlim([0 length(H_NMF{1, 4})])
ylim([0 0.15])
drawnow
A{5}=sleepdata.rw;
NumberOfAssemblies= get_patterns(A{4});

if (NumberOfAssemblies~=0)
[W_NMF{5},H_NMF{5},~]=NMF(A{5},NumberOfAssemblies);
%[~,W{4},~,~,~]=functional_connectivty(A{4},A{4},3,0);
else
    W_NMF{5}=0;
    H_NMF{5}=0;
end
figure
h1=subplot(2,1,1);
imagesc(A{5})
h1=subplot(2,1,2);
plot(H_NMF{1, 5}')
xlim([0 length(H_NMF{1, 5})])
ylim([0 0.15])
drawnow
A{6}=sleepdata.rem;
NumberOfAssemblies= get_patterns(A{4});
if (NumberOfAssemblies~=0)
[W_NMF{6},H_NMF{6},~]=NMF(A{6},NumberOfAssemblies);
%[~,W{4},~,~,~]=functional_connectivty(A{4},A{4},3,0);
else
    W_NMF{6}=0;
    H_NMF{6}=0;
end
figure
h1=subplot(2,1,1);
imagesc(A{6})
h1=subplot(2,1,2);
plot(H_NMF{1, 6}')
xlim([0 length(H_NMF{1, 6})])
ylim([0 0.15])
drawnow
A{7}=sleepdata.nrem;
NumberOfAssemblies= get_patterns(A{4});
if (NumberOfAssemblies~=0)
[W_NMF{7},H_NMF{7},~]=NMF(A{7},NumberOfAssemblies);
%[~,W{4},~,~,~]=functional_connectivty(A{4},A{4},3,0);
else
    W_NMF{7}=0;
    H_NMF{7}=0;
end
figure
h1=subplot(2,1,1);
imagesc(A{7})
h1=subplot(2,1,2);
plot(H_NMF{1, 7}')
xlim([0 length(H_NMF{1, 7})])
ylim([0 0.15])
drawnow
A{8}=obj(:,round(sf*10500+1):round(sf*11100));
NumberOfAssemblies= get_patterns(A{5});

if (NumberOfAssemblies~=0)
[W_NMF{8},H_NMF{8},~]=NMF(A{8},NumberOfAssemblies);
%[~,W{8},~,~,~]=functional_connectivty(A{8},A{8},3,0);
else
    W_NMF{8}=0;
    H_NMF{8}=0;
end
figure
h1=subplot(2,1,1);
imagesc(A{8})
h1=subplot(2,1,2);
plot(H_NMF{1, 8}')
xlim([0 length(H_NMF{1, 8})])
ylim([0 0.15])
drawnow
A{9}=obj(:,round(sf*11100+1):round(sf*11700));
NumberOfAssemblies= get_patterns(A{6});

if (NumberOfAssemblies~=0)
[W_NMF{9},H_NMF{9},~]=NMF(A{9},NumberOfAssemblies);
%[~,W{9},~,~,~]=functional_connectivty(A{9},A{9},3,0);
else
    W_NMF{9}=0;
    H_NMF{9}=0;
end


figure
h1=subplot(2,1,1);
imagesc(A{9})
h1=subplot(2,1,2);
plot(H_NMF{1, 9}')
xlim([0 length(H_NMF{1, 9})])
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
    