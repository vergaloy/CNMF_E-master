function [N,G,R,mini,av]=NSNA_bootstrap(mini)

% [N,G,R,clean]=NSNA_bootstrap(mini);
[mini,av]=clasiffy_minis(mini);
sims=1000;
parfor s=1:sims
I=datasample(1:size(mini,1),size(mini,1));
tmini=mini(I,:);
tav=av(I,:)
[N(s),G(s),R(s)]=NSNA(tmini,0,0,tav);
% NSNA(tmini,1,0,tav);
end


end



