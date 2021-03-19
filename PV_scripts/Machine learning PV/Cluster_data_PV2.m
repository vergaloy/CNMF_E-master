function [K,HM,Z,L,clus]=Cluster_data_PV2(datain,varargin)

%% INTIALIZE VARIABLES
inp = inputParser;
valid_v = @(x) isnumeric(x);
valid_c = @(x) ischar(x);
warning off
addRequired(inp,'datain',valid_v)
addParameter(inp,'plotme',0,valid_v)  %plot data
addParameter(inp,'remove_0s',1,valid_v)  %alpha
addParameter(inp,'alpha',0.05,valid_v)  %alpha
addParameter(inp,'Cdist','correlation')  % Distance metric
addParameter(inp,'Cmethod','average',valid_c )  % Clustering method
addParameter(inp,'m',[])  %alpha
addParameter(inp,'selective',0)  %alpha

inp.KeepUnmatched = true;
parse(inp,datain,varargin{:});
Cdist=inp.Results.Cdist;
Cmethod=inp.Results.Cmethod;
plotme=inp.Results.plotme;
remove_0s=inp.Results.remove_0s;
m=inp.Results.m;
alpha=inp.Results.alpha;



%% remove zeros
if (remove_0s==1)
    [datain,active]=remove_zeros(datain);
else
    active=ones(size(datain,1),1);
end



%% Get cluster strength
HM=get_distance(datain,Cdist,m);
Z=linkage(datain,Cmethod,{Cdist,m});
c = cophenet(Z,squareform(1-HM,'tovector'));
L=find_leaves_in_node(Z);
P2=cluster_strength_agglomerative(datain,Cmethod,Cdist,m,alpha);
[~,P2]=get_clusters(P2,L);
P2=P2>0;
S=P2;
[clus,~]=get_clusters(S,L);

%% Plot stuff
if (plotme==1)
    h=plot_cluster_heatmap(HM,Z,L,clus);
end
K=get_connectome_binary(clus,active);

end
%%

function [data,active]=remove_zeros(data)
X=data;
n=size(X,2)-1;
for i=1:size(X,1)
    ct=X(i,:);
    temp=CXCORR(ct,ct);
    C(i,:)=temp(2:n+1);
end
P0=mean(C(:,50:end),2);
active=1-P0;
len=size(X,2);
active=active.^len;
active=active<0.05;
data=data(active,:);
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


function P=cluster_strength_agglomerative(datain,Cmethod,Cdist,m,alpha)
sim=10000;
parfor s=1:sim
    warning off
    temp = circshift_columns(datain')';
    O=cluster_linkage(temp,Cmethod,Cdist,m)
    per(:,s)=O;
end
Rt=linkage(datain,Cmethod,{Cdist,m});
L=find_leaf_length(Rt);
Rt=Rt(:,3);
thr=prctile(per,alpha*100,2);
for i=1:size(Rt,1)
    P(i)=Rt(i)<thr(L(i));
end
% violin(1-X(:,1:12));plot(1-thr(2:13),'or','MarkerSize',6,'MarkerFaceColor','r');xlabel('cluster size');ylabel('Correlation')

end
function O=cluster_linkage(temp,Cmethod,Cdist,m)
Z=linkage(temp,Cmethod,{Cdist,m});
L=find_leaf_length(Z);
O(1:size(L,2)+1)=nan;
u=unique(L);
for i=1:size(u,2)
    O(u(i))=min(Z(L==u(i),3));
end
end

function out=find_leaf_length(Z)
M=size(Z,1)+1;
Z = num2cell(Z(:,1:2),2);
for i=1:size(Z,1)
    temp=Z{i, 1};
    while (ismember(1,temp>M))
        f=find(temp>M,1);
        k=temp(f);
        temp(f)=[];
        temp=[temp,Z{k-M, 1}];
    end
    out(i)=length(temp);
end
end


function L=minimal_cluster_linkage(datain,Cdist,Cmethod)
HM=get_distance(datain,Cdist,m);
HM=1-HM;
for i=4:-1:2
    b=nchoosek(1:size(HM,1),i);
    for j=1:size(b,1)
        temp=squareform(HM(b(j,:),b(j,:)),'tovector');
        Z=linkage(temp,Cmethod);
        li(j)=Z(end);
    end
    L(i)=min(li);
end
end






