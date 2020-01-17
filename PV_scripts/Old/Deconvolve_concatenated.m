temp=transpose(neuron.C_raw);
B = reshape(temp,1,size(neuron.C_raw,1)*size(neuron.C_raw,2));
neuron.C=B;
C = deconvTemporal(B, 1,1);