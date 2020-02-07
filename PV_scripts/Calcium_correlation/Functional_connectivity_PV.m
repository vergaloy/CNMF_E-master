function [W,H]=Functional_connectivity_PV(neuron);

HC=neuron.S(:,1:3000);
HC=moving_mean(HC,10,2,0.5,0);
[W{1},H{1}]=Get_connectivity(HC);

Train=neuron.S(:,5000:8000);
Train=moving_mean(Train,10,2,0.5,0);
[W{2},H{2}]=Get_connectivity(Train);

A=neuron.S(:,14010:17009);
A=moving_mean(A,10,2,0.5,0);
[W{3},H{3}]=Get_connectivity(A);

C=neuron.S(:,17012:20011);
C=moving_mean(C,10,2,0.5,0);
[W{4},H{4}]=Get_connectivity(C);

B=neuron.S(:,23012:26611);
B=moving_mean(B,10,2,0.5,0);
[W{5},H{5}]=Get_connectivity(B);

dummy=1;