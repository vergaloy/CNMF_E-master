% -------------------------      MERGING      -------------------------  %
show_merge = true;  % if true, manually verify the merging step
merge_thr = 0.25;     % thresholds for merging neurons; [spatial overlap ratio, temporal correlation of calcium traces, spike correlation]
method_dist = 'mean';   % method for computing neuron distances {'mean', 'max'}
dmin = 12;       % minimum distances between two neurons. it is used together with merge_thr
dmin_only = 120000;  % merge neurons if their distances are smaller than dmin_only.
merge_thr_spatial = [0.01, 0.02, -inf];  % merge components with highly correlated spatial shapes (corr=0.8) and small temporal correlations (corr=0.1)


neuron.merge_neurons_dist_corr(show_merge);
