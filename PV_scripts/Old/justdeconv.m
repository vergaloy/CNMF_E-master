function neuron=justdeconv(neuron)
%'foopsi', 'constrained', 'thresholded'
neuron.options.deconv_method='foopsi';
neuron.options.deconv_options.type  ='ar1';
neuron.options.smin=-3;

neuron.C = deconvTemporal(neuron, 1,1);



  % neuron.orderROIs('pnr');   % order neurons in different ways {'snr', 'decay_time', 'mean', 'circularity'}
   % neuron.viewNeurons([], neuron.C_raw);