function [K,HM,Z,L,clus]=linkage_thr(datain,varargin)

%% INTIALIZE VARIABLES
inp = inputParser;
valid_v = @(x) isnumeric(x);
valid_c = @(x) ischar(x);
addRequired(inp,'datain',valid_v) 
addParameter(inp,'plotme',0,valid_v)  %plot data
addParameter(inp,'remove_0s',1,valid_v)  %alpha
addParameter(inp,'alpha',0.05,valid_v)  %alpha
addParameter(inp,'Cdist','correlation')  % Distance metric
addParameter(inp,'Cmethod','average',valid_c )  % Clustering method
addParameter(inp,'m',[])  %alpha


inp.KeepUnmatched = true;
parse(inp,datain,varargin{:});
warning off
Cdist=inp.Results.Cdist;
Cmethod=inp.Results.Cmethod;
plotme=inp.Results.plotme;
remove_0s=inp.Results.remove_0s;
m=inp.Results.m;
alpha=inp.Results.alpha;

%%=============================================================================
% datain(datain>0)=1;

%% remove zeros
if (remove_0s==1)
[datain,active]=remove_zeros(datain);
else
    active=ones(size(datain,1),1);
end



%% Get cluster strength
HM=get_distance(datain,Cdist,m);
 Z=linkage(datain,Cmethod,{Cdist,m});
 thr=get_thr(datain,Cmethod,{Cdist,m});
 S=Z(:,3)<thr;
 c = cophenet(Z,squareform(1-HM,'tovector'))
 L=find_leaves_in_node(Z);
[clus,~]=get_clusters(S,L); 
 
 
 
 


%% Plot stuff
if (plotme==1)
h=plot_cluster_heatmap(HM,Z,L,clus);
end
K=get_connectome_binary(clus,active);

end
%%

function [data,active]=remove_zeros(data)
len=size(data,2);
active=data;
active(active~=0)=1;
active=1-mean(active,2);
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

function thr=get_thr(datain,Cmethod,Cdist)

for s=1:1000
    temp=shuffle_row(datain);
    temp=linkage(temp,Cmethod,Cdist);
    S(:,s)=temp(:,3);
end

thr=prctile(S,5,2);
end


function out=shuffle_row(in)
out=zeros(size(in,1),size(in,2));
for i=1:size(in,1)
    out(i,:)=in(i,randperm(size(in,2),size(in,2)));   
end
end





