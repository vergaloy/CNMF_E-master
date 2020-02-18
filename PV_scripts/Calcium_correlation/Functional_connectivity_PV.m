function [W,H,Y,stress]=Functional_connectivity_PV(C);

for i=1:length(C)
[W{i},H{i}]=Get_connectivity(C{i});
end

[Y,stress]=PVD_bootstrap(W,25);

dummy=1;