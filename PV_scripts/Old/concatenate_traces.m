%% parameters
% -------------------------    COMPUTATION    -------------------------  %
pars_envs = struct('memory_size_to_use', 120, ...   % GB, memory space you allow to use in MATLAB
    'memory_size_per_patch', 8, ...   % GB, space for loading data within one patch
    'patch_dims', [1, 1]);  %GB, patch size

% -------------------------      SPATIAL      -------------------------  %
gSig = 4;           % pixel, gaussian width of a gaussian kernel for filtering the data. 0 means no filtering
gSiz = 12;          % pixel, neuron diameter
ssub = 1;           % spatial downsampling factor
with_dendrites = false;   % with dendrites or not
if with_dendrites
    % determine the search locations by dilating the current neuron shapes
    updateA_search_method = 'dilate';  %#ok<UNRCH>
    updateA_bSiz = 5;
    updateA_dist = neuron.options.dist;
else
    % determine the search locations by selecting a round area
    updateA_search_method = 'ellipse'; %#ok<UNRCH>
    updateA_dist = 5;
    updateA_bSiz = neuron.options.dist;
end
spatial_constraints = struct('connected', true, 'circular', false);  % you can include following constraints: 'circular'
spatial_algorithm = 'hals_thresh';

% -------------------------      TEMPORAL     -------------------------  %
Fs = 5.02;             % frame rate
tsub = 1;           % temporal downsampling factor
deconv_options = struct('type', 'ar1', ... % model of the calcium traces. {'ar1', 'ar2'}
    'method', 'foopsi', ... % method for running deconvolution {'foopsi', 'constrained', 'thresholded'}
    'smin', -3, ...         % minimum spike size. When the value is negative, the actual threshold is abs(smin)*noise level
    'optimize_pars', true, ...  % optimize AR coefficients
    'optimize_b', true, ...% optimize the baseline);
    'max_tau', 80);    % maximum decay time (unit: frame);

nk = 30;             % detrending the slow fluctuation. usually 1 is fine (no detrending)  
% when changed, try some integers smaller than total_frame/(Fs*30)
detrend_method = 'spline';  % compute the local minimum as an estimation of trend.

% -------------------------     BACKGROUND    -------------------------  %
bg_model = 'ring';  % model of the background {'ring', 'svd'(default), 'nmf'}
nb = 1;             % number of background sources for each patch (only be used in SVD and NMF model)
ring_radius = 25;  % when the ring model used, it is the radius of the ring used in the background model.  %PV 18 was working fine
%otherwise, it's just the width of the overlapping area
num_neighbors = []; % number of neighbors for each neuron

% -------------------------      MERGING      -------------------------  %
show_merge = false;  % if true, manually verify the merging step
merge_thr = 0.45;     % thresholds for merging neurons; [spatial overlap ratio, temporal correlation of calcium traces, spike correlation]
method_dist = 'mean';   % method for computing neuron distances {'mean', 'max'}
dmin = 12;       % minimum distances between two neurons. it is used together with merge_thr
dmin_only = 12;  % merge neurons if their distances are smaller than dmin_only.
merge_thr_spatial = [0.8, 0.1, -inf];  % merge components with highly correlated spatial shapes (corr=0.8) and small temporal correlations (corr=0.1)

% -------------------------  INITIALIZATION   -------------------------  %
K = [];             % maximum number of neurons per patch. when K=[], take as many as possible.
min_corr = 0.7;     % minimum local correlation for a seeding pixel  pv=0.7
min_pnr = 6;       % minimum peak-to-noise ratio for a seeding pixel   PV=6
min_pixel = (gSig-2)^2;      % minimum number of nonzero pixels for each neuron
bd = 0;             % number of rows/columns to be ignored in the boundary (mainly for motion corrected data)
frame_range = [];   % when [], uses all frames
save_initialization = false;    % save the initialization procedure as a video.
use_parallel = true;    % use parallel computation for parallel computing
show_init = true;   % show initialization results
choose_params = false; % manually choose parameters
center_psf = true;  % set the value as true when the background fluctuation is large (usually 1p data)
% set the value as false when the background fluctuation is small (2p)

% -------------------------  Residual   -------------------------  %
min_corr_res = 0.7;   %@v 0.7
min_pnr_res = 6;  %PV 6
seed_method_res = 'auto';  % method for initializing neurons from the residual
update_sn = true;

% ----------------------  WITH MANUAL INTERVENTION  --------------------  %
with_manual_intervention = false;

% -------------------------  FINAL RESULTS   -------------------------  %
save_demixed = true;    % save the demixed file or not
kt = 1;                 % frame intervals

% -------------------------    UPDATE ALL    -------------------------  %
neuron.updateParams('gSig', gSig, ...       % -------- spatial --------
    'gSiz', gSiz, ...
    'ring_radius', ring_radius, ...
    'ssub', ssub, ...
    'search_method', updateA_search_method, ...
    'bSiz', updateA_bSiz, ...
    'dist', updateA_bSiz, ...
    'spatial_constraints', spatial_constraints, ...
    'spatial_algorithm', spatial_algorithm, ...
    'tsub', tsub, ...                       % -------- temporal --------
    'deconv_options', deconv_options, ...
    'nk', nk, ...
    'detrend_method', detrend_method, ...
    'background_model', bg_model, ...       % -------- background --------
    'nb', nb, ...
    'ring_radius', ring_radius, ...
    'num_neighbors', num_neighbors, ...
    'merge_thr', merge_thr, ...             % -------- merging ---------
    'dmin', dmin, ...
    'method_dist', method_dist, ...
    'min_corr', min_corr, ...               % ----- initialization -----
    'min_pnr', min_pnr, ...
    'min_pixel', min_pixel, ...
    'bd', bd, ...
    'center_psf', center_psf);
neuron.Fs = Fs;

n=size(neuron.ids,2);
frames=(size(neuron.C_raw,2)+size(neuron1.C_raw,2));

c=zeros([n frames]);
c(1:n,1:size(neuron.C_raw,2))=neuron.C_raw;
c(1:n,size(neuron.C_raw,2)+1:frames)=neuron1.C_raw;
neuron.C_raw=c;
clear c
neuron.C = deconvTemporal(neuron, use_parallel,1);