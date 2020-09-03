function [N,G,R]=NSNA_bootstrap(data)
% [N(:,4),G(:,4),R(:,4)]=NSNA_bootstrap(late_slow);
sim=1000;
N=zeros(1,sim);G=zeros(1,sim);R=zeros(1,sim);
parfor s=1:sim
    bsamp=datasample(data,size(data,1),1);
    [N(s),G(s),R(s)]=NSNA(bsamp,0);
    if (N(s)<0)
        dummy=1
    end
end
