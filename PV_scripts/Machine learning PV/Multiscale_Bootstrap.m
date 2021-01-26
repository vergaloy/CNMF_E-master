function [AU,BP,SI,SIC]=Multiscale_Bootstrap(datain,varargin)
% [AU,BP,L,Z]=Multiscale_Bootstrap(D{2, 2});

%INPUTS
inp = inputParser;
valid_v = @(x) isnumeric(x);
valid_c = @(x) ischar(x);
addRequired(inp,'datain',valid_v)
addParameter(inp,'Cdist','correlation')  % Distance metric
addParameter(inp,'Cmethod','average',valid_c )  % Clustering method
addParameter(inp,'m',1)  % Clustering method
inp.KeepUnmatched = true;
parse(inp,datain,varargin{:});
warning off
Cdist=inp.Results.Cdist;
Cmethod=inp.Results.Cmethod;
m=inp.Results.m;
%% intilize variables
lin=linspace(0.5,1.5,10);
x=sqrt(1./lin);
bp=zeros(size(datain,1)-1,length(x));
AU=zeros(size(datain,1)-1,1);
%% get BP
sim=1000;
% upd = textprogressbar(length(x));
for i=1:length(lin)
    rep=round(size(datain,2)*lin(i)) ;
    [bp(:,i),~,~]=hierarchical_cluster_bootstrap(datain,rep,Cmethod,sim,Cdist,m);
%     upd(i);
end
%% get AU
bp(bp==1)=1-1/(sim+1);
for i=1:size(bp,1)-1
    [AU(i),BP(i),SI(i),SIC(i),err(i)]=linear_regression_AU(x,bp(i,:));
end
SI=max([SI;BP],[],1);
SI=[SI,0];
SIC=[SIC,0];



end


%%%%
function [AU,BP,SI,SIC,err]=linear_regression_AU(x,bp)
psy=norminv(bp).*x;
I=isfinite(psy);
    psy=psy(I);
try
    x=x(I);
    [fitted_curve,gof,~] = fit(x.^2',psy','poly1','Robust','LAR');
    coeff = coeffvalues(fitted_curve);
    
    B0=coeff(2);
    B1=coeff(1);
    
    AU=normcdf(B0-B1,'upper');
    BP=normcdf(B0+B1,'upper');
    
    SI=normcdf(B0-B1,'upper')/normcdf(-B1,'upper');
    SIC=normcdf(-B0+B1,'upper')/normcdf(B1,'upper');
    
    if (SI>1)
        SI=1-SIC;
    end
    
    if (SIC>1)
        SIC=1-SI;
    end
    err=gof.rmse/iqr(psy);
    % plot(fitted_curve, x.^2, psy);
catch
    AU=1-mean(bp);
    BP=1-mean(bp);
    SI=1-mean(bp);
    SIC=mean(bp);
    err=999;
end
end





