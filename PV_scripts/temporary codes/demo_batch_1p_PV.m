
% Specify the folder where the files live.
myFolder ='C:\Users\BigBrain\Desktop\Tracking neuron\Pre and Post shock\A and B';
savefiles=1;
% Check to make sure that folder actually exists.  Warn user if it doesn't.


filePattern = fullfile(myFolder, '*.h5'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
for k=1:length(theFiles)
    
    tic
    clearvars -except filePattern theFiles k myFolder
    close all
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    
    fprintf(1, 'Now read   ing %s\n', fullFileName);
    %% Constrained Nonnegative Matrix Factorization for microEndoscopic data  * *
    %% *STEP*0: select data
    
    warning('off','all') 
    neuron = Sources2D();
    nams = {fullFileName};          % this demo data is very small, here we just use it as an example
    nams = {neuron.select_multiple_files(nams)};  %if nam is [], then select data interactively
    
    %% parameters
    % -------------------------    COMPUTATION    -------------------------  %
    pars_envs = struct('memory_size_to_use', 256, ...   % GB, memory space you allow to use in MATLAB
        'memory_size_per_patch', 40, ...   % GB, space for loading data within one patch
        'patch_dims', [64, 64],...  %GB, patch size
        'batch_frames', 1000);           % number of frames per batch
    % -------------------------      SPATIAL      -------------------------  %
    gSig = 4;           % pixel, gaussian width of a gaussian kernel for filtering the data. 0 means no filtering. USE ODD numbers
    gSiz = 12;          % pixel, neuron diameter
    ssub = 1;           % spatial downsampling factor
    with_dendrites = false;   % with dendrites or not
    if with_dendrites
        % determine the search locations by dilating the current neuron shapes
        updateA_search_method = 'dilate';
        updateA_bSiz = 5;
        updateA_dist = neuron.options.dist;
    else
        % determine the search locations by selecting a round area
        updateA_search_method = 'ellipse'; %#ok<UNRCH>
        updateA_dist = 5;
        updateA_bSiz = neuron.options.dist;
    end
    spatial_constraints = struct('connected', true, 'circular', true);  % you can include following constraints: 'circular'
    spatial_algorithm = 'hals';
    
    % -------------------------      TEMPORAL     -------------------------  %
    Fs = 5;             % frame rate
    tsub = 1;           % temporal downsampling factor
    deconv_options = struct('type', 'ar1', ... % model of the calcium traces. {'ar1', 'ar2'}
        'method', 'foopsi', ... % method for running deconvolution {'foopsi', 'constrained', 'thresholded'}
        'smin', -5, ...         % minimum spike size. When the value is negative, the actual threshold is abs(smin)*noise level
        'optimize_pars', true, ...  % optimize AR coefficients
        'optimize_b', true, ...% optimize the baseline);
        'max_tau', 100);    % maximum decay time (unit: frame);
    
    nk = 5;             % detrending the slow fluctuation. usually 1 is fine (no detrending)
    % when changed, try some integers smaller than total_frame/(Fs*30)
    detrend_method = 'spline';  % compute the local minimum as an estimation of trend.
    
    % -------------------------     BACKGROUND    -------------------------  %
    bg_model = 'ring';  % model of the background {'ring', 'svd'(default), 'nmf'}
    nb = 1;             % number of background sources for each patch (only be used in SVD and NMF model)
    bg_neuron_factor = 1.4;
    ring_radius = round(bg_neuron_factor * gSiz);  % when the ring model used, it is the radius of the ring used in the background model.
    %otherwise, it's just the width of the overlapping area
    num_neighbors = []; % number of neighbors for each neuron
    bg_ssub = 1;        % downsample background for a faster speed
    % -------------------------      MERGING      -------------------------  %
    show_merge = false;  % if true, manually verify the merging step
    merge_thr = 0.65;     % thresholds for merging neurons; [spatial overlap ratio, temporal correlation of calcium traces, spike correlation]
    method_dist = 'max';   % method for computing neuron distances {'mean', 'max'}
    dmin = 5;       % minimum distances between two neurons. it is used together with merge_thr
    dmin_only = 2;  % merge neurons if their distances are smaller than dmin_only.
    merge_thr_spatial = [0.8, 0.4, -inf];  % merge components with highly correlated spatial shapes (corr=0.8) and small temporal correlations (corr=0.1)
    
    % -------------------------  INITIALIZATION   -------------------------  %
    K = [];             % maximum number of neurons per patch. when K=[], take as many as possible.
    min_corr = 0.7;     % minimum local correlation for a seeding pixel
    min_pnr = 7;       % minimum peak-to-noise ratio for a seeding pixel
    min_pixel = gSig^2;      % minimum number of nonzero pixels for each neuron
    bd = 0;             % number of rows/columns to be ignored in the boundary (mainly for motion corrected data)
    frame_range = [];   % when [], uses all frames
    save_initialization = false;    % save the initialization procedure as a video.
    use_parallel = true;    % use parallel computation for parallel computing
    show_init = false;   % show initialization results
    choose_params = false; % manually choose parameters
    center_psf = true;  % set the value as true when the background fluctuation is large (usually 1p data)
    % set the value as false when the background fluctuation is small (2p)
    
    % -------------------------  Residual   -------------------------  %
    min_corr_res = 0.7;
    min_pnr_res = 6;
    seed_method_res = 'auto';  % method for initializing neurons from the residual
    update_sn = true;
    
    % ----------------------  WITH MANUAL INTERVENTION  --------------------  %
    with_manual_intervention = false;   
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
        'bg_ssub', bg_ssub, ...%
        'merge_thr', merge_thr, ...             % -------- merging ---------
        'dmin', dmin, ...
        'method_dist', method_dist, ...
        'min_corr', min_corr, ...               % ----- initialization -----
        'min_pnr', min_pnr, ...
        'min_pixel', min_pixel, ...
        'bd', bd, ...
        'center_psf', center_psf);
    neuron.Fs = Fs;
    
    %% distribute data and be ready to run source extraction
    neuron.getReady_batch(pars_envs);
    
    %% initialize neurons in batch mode
    neuron.initComponents_batch(K, save_initialization, 1);
    
    %% udpate spatial components for all batches
    neuron.update_spatial_batch(use_parallel);
    
    %% udpate temporal components for all bataches
    neuron.update_temporal_batch(use_parallel);
    
    %% update background
    neuron.update_background_batch(use_parallel);
    neuron.update_temporal_batch(use_parallel);
    normalize_C_raw(neuron)  
    %% get the correlation image and PNR image for all neurons
    neuron.correlation_pnr_batch();
    [neuron.PNR_all,neuron.Cn_all]=create_PNR_batch(neuron);
    %% concatenate temporal components
    concatenate_shifted_batch(neuron);
    neuron.P=neuron.batches{1, 1}.neuron.P;
    neuron.frame_range=[1,size(neuron.C_raw,2)];
    

    neuron=justdeconv(neuron,'foopsi','ar1');
    
    neuron.merge_neurons_dist_corr(0);
    neuron.merge_high_corr(0, [0.8, 0.00001, -inf]);

 
    fix_Baseline(round(40*neuron.Fs),neuron)%% PV
    scale_to_noise(neuron,500);
    neuron=justdeconv(neuron,'foopsi','ar1');
 

    neuron.merge_neurons_dist_corr(0);
    neuron.merge_high_corr(0, [0.6, -1, -inf]);

    %% save workspace
    neuron.P.log_folder=strcat(neuron.P.folder_analysis,filesep);
    neuron.save_workspace_batch();
    fclose('all');
  
end

%neuron.P.log_file=strcat(uigetdir,filesep,'log_',date,'.txt');
%neuron.P.log_folder=strcat(uigetdir,'\'); %update the folder
%neuron.Coor=[]
%neuron.show_contours(0.6, [], neuron.PNR, 1)
%neuron.show_contours(0.6, [], neuron.Cn, 0)
%neuron.show_contours(0.6, [], neuron.PNR.*neuron.Cn, 1)

%neuron.orderROIs('PNR');   % order neurons in different ways {'snr', 'decay_time', 'mean', 'circularity','sparsity_spatial','sparsity_temporal','pnr'}
% neuron.viewNeurons([], neuron.C_raw); 

%neuron.batches=0;  %kill batch data, it is not necessary to save
%cnmfe_path = neuron.save_workspace();

%mat2clip(neuron.C_raw');
%mat2clip(neuron.C_raw(:,7501:52500)');

%show_demixed_video_PV(neuron,[3000 6000],2);

% neuron.change_path('/data/home/zhoupc/', '/Users/zhoupc/');  %change path info when we switch computers and want to reuse previous results