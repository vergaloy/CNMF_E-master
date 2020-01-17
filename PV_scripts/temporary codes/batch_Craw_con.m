function batch_Craw_con(neuron)

t=neuron.batches{1, 1}.neuron.C_raw;

for i=2:size(neuron.batches,1)
    t=[t,neuron.batches{i, 1}.neuron.C_raw];

end
neuron.C_raw=t;
neuron.C = deconvTemporal(neuron, 1,1);