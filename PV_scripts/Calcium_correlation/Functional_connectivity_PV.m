function [W,H,E]=Functional_connectivity_PV(C);
clear textprogressbar
warning('off','all')

textprogressbar('Finding patterns: ');
for i=1:length(C)
textprogressbar((i/length(C))*100)
[W{i},H{i},E(i)]=Get_connectivity(C{i});
end
textprogressbar('Done: ');
