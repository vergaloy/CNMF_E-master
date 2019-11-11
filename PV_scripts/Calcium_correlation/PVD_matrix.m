function [matrix,W_NMF]=PVD_matrix(obj,hypno)
%[matrix,W_NMF]=PVD_matrix(temp_bin,hypno)
sf=5.01;
A{1}=obj(:,1:round(sf*600));
NumberOfAssemblies= get_patterns(A{1});
[W_NMF{1},~,~]=NMF(A{1},NumberOfAssemblies);
if (NumberOfAssemblies~=0)
[~,W{1},~,~,~]=functional_connectivty(A{1},A{1},3,0);
else
    W_NMF{1}=0;
end

A{2}=obj(:,round(sf*981):round(sf*1580));
NumberOfAssemblies= get_patterns(A{2});

if (NumberOfAssemblies~=0)
    [W_NMF{2},~,~]=NMF(A{2},NumberOfAssemblies);
else
    W_NMF{2}=0;
end

%[~,W{2},~,~,~]=functional_connectivty(A{2},A{2},3,0);

A{3}=obj(:,round(sf*1581):round(sf*1880));
NumberOfAssemblies= get_patterns(A{3});
if (NumberOfAssemblies~=0)
[W_NMF{3},~,~]=NMF(A{3},NumberOfAssemblies);
else
    W_NMF{3}=0;
end

%[~,W{3},~,~,~]=functional_connectivty(A{3},A{3},3,0);

sleepdata=separate_by_sleep(obj(:,round(sf*1903):round(sf*10903)),hypno(round(sf*1903):round(sf*10903)));
A{4}=sleepdata.wake;
NumberOfAssemblies= get_patterns(A{4});
if (NumberOfAssemblies~=0)
[W_NMF{4},~,~]=NMF(A{4},NumberOfAssemblies);
%[~,W{4},~,~,~]=functional_connectivty(A{4},A{4},3,0);
else
    W_NMF{4}=0;
end


A{5}=sleepdata.rw;
NumberOfAssemblies= get_patterns(A{5});
if (NumberOfAssemblies~=0)
[W_NMF{5},~,~]=NMF(A{5},NumberOfAssemblies);
%[~,W{5},~,~,~]=functional_connectivty(A{5},A{5},3,0);
else
    W_NMF{5}=0;
end



A{6}=sleepdata.rem;
NumberOfAssemblies= get_patterns(A{6});
if (NumberOfAssemblies~=0)
[W_NMF{6},~,~]=NMF(A{6},NumberOfAssemblies);
%[~,W{6},~,~,~]=functional_connectivty(A{6},A{6},3,0);
else
    W_NMF{6}=0;
end


A{7}=sleepdata.nrem;
NumberOfAssemblies= get_patterns(A{7});
if (NumberOfAssemblies~=0)
[W_NMF{7},~,~]=NMF(A{7},NumberOfAssemblies);
%[~,W{7},~,~,~]=functional_connectivty(A{7},A{7},3,0);
else
    W_NMF{7}=0;
end


A{8}=obj(:,round(sf*11110):round(sf*11703));
NumberOfAssemblies= get_patterns(A{8});
if (NumberOfAssemblies~=0)
[W_NMF{8},~,~]=NMF(A{8},NumberOfAssemblies);
%[~,W{8},~,~,~]=functional_connectivty(A{8},A{8},3,0);
else
    W_NMF{8}=0;
end


A{9}=obj(:,round(sf*11739):round(sf*12338));
NumberOfAssemblies= get_patterns(A{9});
if (NumberOfAssemblies~=0)
[W_NMF{9},~,~]=NMF(A{9},NumberOfAssemblies);
%[~,W{9},~,~,~]=functional_connectivty(A{9},A{9},3,0);
else
    W_NMF{9}=0;
end


matrix(1:9,1:9)=0;
comb=nchoosek(1:9,2);

for i=1:size(comb,1)
    matrix(comb(i,1),comb(i,2))=PVD(A{comb(i,1)},A{comb(i,2)},size(A{comb(i,1)},1));
end
matrix=matrix+matrix';


imagesc(matrix);

[mean(A{1},2),mean(A{2},2),mean(A{3},2),mean(A{4},2),mean(A{5},2),mean(A{6},2),mean(A{7},2),mean(A{8},2),mean(A{9},2)]

%colormap(jet)
    