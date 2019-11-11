function [Y,trueC, trueS,pattern]=Simulated_calcium_trace() 
%[Y,trueC, trueS,pattern]=Simulated_calcium_trace();
g = [1.7, -0.712]; % AR coefficient 
noise = 1;       
b = 0;              % baseline
%=============================================
T = 30000; %54000
N = 20;              % number of cells
patterns=2;
cellperpattern=[5 5]; %per frame [4 4];
pattern_rate=0.001;   %per frame 0.0009;
non_pattern_rate=0.0015;%per frame 0.001
other_Cells_rate=0.002;%per frame 0.002;
Spike_per_burst=15;%per frame 8
seed=rng('shuffle');
[trace,pattern]=make_spikes(N,T,patterns,cellperpattern,pattern_rate,non_pattern_rate,Spike_per_burst,other_Cells_rate);
[Y, trueC, trueS] = gen_data_PV(g, noise, T, b, N,trace); 
