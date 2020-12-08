function S=linkage_clustering(datain,varargin)

%% INTIALIZE VARIABLES
inp = inputParser;
valid_v = @(x) isnumeric(x);
valid_c = @(x) ischar(x);
addRequired(inp,'datain',valid_v) 
addParameter(inp,'Cdist','correlation')  % Distance metric
addParameter(inp,'Cmethod','average',valid_c )  % Clustering method
addParameter(inp,'m',[])  %alpha


inp.KeepUnmatched = true;
parse(inp,datain,varargin{:});
warning off
Cdist=inp.Results.Cdist;
Cmethod=inp.Results.Cmethod;
m=inp.Results.m;


%%=============================================================================


%% Get cluster strength
 Z=linkage(datain,Cmethod,{Cdist,m});
 thr=get_thr(datain,Cmethod,{Cdist,m});
 S=Z(:,3)<thr;

 

end
%%


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





