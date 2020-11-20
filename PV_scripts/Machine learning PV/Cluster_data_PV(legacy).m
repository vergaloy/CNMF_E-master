function [K,AU,BP,h,C]=Cluster_data_PV(datain,varargin)

%% INTIALIZE VARIABLES
inp = inputParser;
valid_v = @(x) isnumeric(x);
valid_c = @(x) ischar(x);
addRequired(inp,'datain',valid_v) 
addParameter(inp,'plotme',0,valid_v)  %plot data
addParameter(inp,'alpha',0.05,valid_v)  %alpha
addParameter(inp,'remove_0s',1,valid_v)  %alpha
addParameter(inp,'Cdist','correlation',valid_c )  % Distance metric
addParameter(inp,'Cmethod','average',valid_c )  % Clustering method
addParameter(inp,'Standarize','Column',valid_c )  % Standarize data (only for visualization)
addParameter(inp,'LeafOrder',0,valid_v ) 
addParameter(inp,'cluster_distance_matrix','no') 
inp.KeepUnmatched = true;
parse(inp,datain,varargin{:});
warning off
Cdist=inp.Results.Cdist;
Cmethod=inp.Results.Cmethod;
plotme=inp.Results.plotme;
Standarize=inp.Results.Standarize;
alpha=inp.Results.alpha;
remove_0s=inp.Results.remove_0s;
LeafOrder=inp.Results.LeafOrder;
cluster_distance_matrix=inp.Results.cluster_distance_matrix;

%%=============================================================================
%% remove zeros
if (remove_0s==1)
[datain,active]=remove_zeros(datain);
else
    active=ones(size(datain,1),1);
end
%% keep some data:
save_data=datain;
dist=Cdist;
%% create distance matrix (if clustering is done over the distance matrix)
if ~(strcmp(cluster_distance_matrix,'no'))
    datain=get_distance(datain,cluster_distance_matrix);
    dist=cluster_distance_matrix;
end

%% Perform Multiscale boostrap
[AU,BP,L,Z]=Multiscale_Bootstrap(datain,'Cmethod',Cmethod,'Cdist',Cdist);

%% Get cluster strength
P=clusterCorr_P(save_data,L,dist); %% this can be any clustering method.
[~, ~,~, P]=fdr_bh(1-P);
P=1-P;
% P=[1;P];
P(isnan(P))=0;
S=(AU>(1-alpha)).*P>0.95;
%% get clusters
[clus,~]=get_clusters(S,L);
% subclus=find_sub_clust(clus,L,P,alpha);



    C=update_C(L,clus);  %% get colors for ploting
    h=clustergram(datain','Cluster','all', 'RowPDist',Cdist,'ColumnPDist',Cdist,...
        'Colormap','parula','Standardize',Standarize,...
        'OptimalLeafOrder',LeafOrder,'Linkage',Cmethod,'Symmetric',false);
%% Plot stuff
if (plotme==1)
     color_cluster(C,h);
     view(h);
%     [h,~,~]=dendrogram(Z,0);
%     color_tree(C,h);
end
K=get_connectome_binary(clus,active);

end
%%

function out=find_sub_clust(clus,L,P,alpha)
n=size(clus,1);
out={};
for i=1:n
    temp=clus{i, 1};  
    sub=sub_clusters(temp,L,P,alpha);
    out=[out;sub];
end
% B = cellfun(@(v)sort(char(v)),clus,'uni',0);
% out = cellfun(@double,unique(B),'uni',0);
end


function sub=sub_clusters(v,L,P,alpha)
sub={};
k=0;
for i=1:numel(L)
    if (prod(ismember(L{i,1},v))==1)
        k=k+1;
      sub{k,1}= L{i,1};
      sub{k,2}= P(i);
    end
end
sub([sub{:,2}]<(1-alpha),:)=[];
[sub,~]=get_clusters([sub{:,2}]',sub(:,1),alpha);
end




function [data,active]=remove_zeros(data)
data=bin_data(data,1,5);
len=size(data,2);
active=data;
active(active~=0)=1;
active=1-mean(active,2);
active=active.^len;
active=active<0.05;
data=data(active,:);
end

function [clus,C]=get_clusters(S,L)
C=zeros(1,size(L,1));
for i=length(S):-1:1
    if (S(i))
        for k=1:size(L,1)
            if (ismember(L{k},L{i}))
                if (k~=i)
                    L{k}=[];
                    C(k)=i;
                end
                C(k)=i;
            end
        end
    else
        L{i}=[];
    end
end
clus=L;
clus=clus(~cellfun('isempty',clus));
u=unique(C);
u(u==0)=[];
for i=1:length(u)
    C(u(i)==C)=i;
end
end

function color_tree(C,h)
set( h([1:length(h)]), 'Color', 'k' );
N=unique(C);
N=N(2:end);
colors = distinguishable_colors(length(N));
for i=1:length(N)
    set( h(C==N(i)), 'Color', colors(i,:));
end
end


function color_cluster(C,Z)

N=unique(C);
N=N(N~=0);
if ~isempty(N)
    colors = num2cell(distinguishable_colors(length(N)),2)';
    for i=1:length(N)
        G{i}=find(N(i)==C,1,'last');
    end
    rm=struct('GroupNumber',G,'Annotation',cell(1,length(N)),'Color',colors);
    set(Z,'ColumnGroupMarker',rm)
end
end


function K=get_connectome_binary(clus,active)
if (~isempty(clus))
    K=zeros(length(active),size(clus,1));
    for i=1:size(K,2)
        temp=zeros(sum(active),1);
        temp(clus{i, 1})=1;
        K(logical(active),i)=temp;
    end
else
    K=[];
end
end


function [P]=get_clust_significance(in,Cdist)
M=mean(in,1);
Rt=get_distance([M;in],Cdist);
Rt=min(Rt(1,2:end));
sim=1000;
Per=zeros(sim,1);
for s=1:sim
    temp=shuffle_row(in);
    M=mean(temp,1);
    temp=get_distance([M;temp],Cdist);
    Per(s)=min(temp(1,2:end));
end
[f,xi] = ksdensity(Per);
f=cumsum(f)/sum(f);
P=1-interp1(xi,f,Rt);
P(isnan(P))=1;
end

function out=shuffle_row(in)
out=zeros(size(in,1),size(in,2));
for i=1:size(in,1)
    out(i,:)=in(i,randperm(size(in,2),size(in,2)));   
end
end

function P=clusterCorr_P(data,L,Cdist)

% U=unique(catpad(1,L{:}))';
% U(isnan(U))=[];
% L=[L;U];
P=zeros(size(L,1),1);
for i=1:size(L,1)
    temp=data(L{i,1},:);
    P(i)=get_clust_significance(temp,Cdist);
end
P=1-P;
end


function C=update_C(L,clus)
k=0;
C=zeros(1,size(L,1));
for i=1:size(clus,1)
    for j=1:size(L,1)
        if (isequal(sort(L{j, 1}),sort(clus{i, 1})))
            k=k+1;
            C(j)=k;
        end
    end
end
end

function out=get_distance(in,distance);
    out=squareform(1-pdist(in,distance))+diag(ones(1,size(in,1)));
    out(isnan(out))=0;
end

