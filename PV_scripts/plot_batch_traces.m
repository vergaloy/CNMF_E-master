n=size(neuron.C_raw,1);

traces=zeros(n*size(neuron.batches,1),size(neuron.C_raw,2));

for i=1:size(neuron.batches,1)
traces(i*n-n+1:i*n,neuron.batches{i, 1}.neuron.frame_range(1):neuron.batches{i, 1}.neuron.frame_range(2))=neuron.batches{i, 1}.neuron.C_raw; 
end

strips(traces');