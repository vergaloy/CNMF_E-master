
% Specify the folder where the files live.
myFolder ='C:\Users\SSG Lab\Desktop\Pablo\191202\analisis\test\test 2\Low_corr\failed\failed\failed';
savefiles=1;
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end

filePattern = fullfile(myFolder, '*.h5'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
for k=1:length(theFiles)
    try
        tic
        clearvars -except filePattern theFiles k myFolder
        close all
        baseFileName = theFiles(k).name;
        fullFileName = fullfile(myFolder, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        %% Constrained Nonnegative Matrix Factorization for microEndoscopic data  * *
        %% *STEP*0: select data
        
        warning('off','all') %add by Natsu
        
        neuron = Sources2D();
        nam = get_fullname(fullFileName);          % this demo data is very small, here we just use it as an example
        nam = neuron.select_data(nam);  %if nam is [], then select data interactively
        %% *Step 1: parameter specification*
        
        % -------------------------    COMPUTATION    -------------------------  %
        %% parameters
        % -------------------------    COMPUTATION    -------------------------  %
        pars_envs = struct('memory_size_to_use', 300, ...   % GB, memory space you allow to use in MATLAB
            'memory_size_per_patch', 64, ...   % GB, space for loading data within one patch
            'patch_dims', [40, 40]);  %GB, patch size
        
        % -------------------------      SPATIAL      -------------------------  %
        gSig = 3;           % pixel, gaussian width of a gaussian kernel for filtering the data. 0 means no filtering
        gSiz = 9;          % pixel, neuron diameter
        ssub = 1;           % spatial downsampling factor
        with_dendrites = false;   % with dendrites or not
        if with_dendrites
            % determine the search locations by dilating the current neuron shapes
            updateA_search_method = 'dilate';  %#ok<UNRCH>
            updateA_bSiz = 5;
            updateA_dist = neuron.options.dist;
        else
            % determine the search locations by selecting a round area
            updateA_search_method = 'ellipse';
            updateA_dist = 10;
            updateA_bSiz = neuron.options.dist;
        end
        spatial_constraints = struct('connected', true, 'circular', true);  % you can include following constraints: 'circular'
        spatial_algorithm = 'nnls_thresh';
        
        % -------------------------      TEMPORAL     -------------------------  %
        Fs = 5.02;             % frame rate
        tsub = 1;           % temporal downsampling factor
        deconv_options = struct('type', 'ar1', ... % model of the calcium traces. {'ar1', 'ar2'}
            'method', 'foopsi', ... % method for running deconvolution {'foopsi', 'constrained', 'thresholded'}
            'smin', -5, ...         % minimum spike size. When the value is negative, the actual threshold is abs(smin)*noise level
            'optimize_pars', true, ...  % optimize AR coefficients
            'optimize_b', true, ...% optimize the baseline);
            'max_tau', 100);    % maximum decay time (unit: frame);
        
        nk = 3;             % detrending the slow fluctuation. usually 1 is fine (no detrending)
        % when changed, try some integers smaller than total_frame/(Fs*30)
        detrend_method = 'spline';  % compute the local minimum as an estimation of trend.
        
        % -------------------------     BACKGROUND    -------------------------  %
        bg_model = 'ring';  % model of the background {'ring', 'svd'(default), 'nmf'}
        nb = 1;             % number of background sources for each patch (only be used in SVD and NMF model)
        ring_radius = gSiz*2;  % when the ring model used, it is the radius of the ring used in the background model.
        %otherwise, it's just the width of the overlapping area
        num_neighbors = []; % number of neighbors for each neuron
        bg_ssub = 2;        % downsample background for a faster speed
        
        % -------------------------      MERGING      -------------------------  %
        show_merge = false;  % if true, manually verify the merging step
        merge_thr = 0.65;     % thresholds for merging neurons; [spatial overlap ratio, temporal correlation of calcium traces, spike correlation]
        method_dist = 'max';   % method for computing neuron distances {'mean', 'max'}
        dmin = 5;       % minimum distances between two neurons. it is used together with merge_thr
        dmin_only = 2;  % merge neurons if their distances are smaller than dmin_only.
        merge_thr_spatial = [0.8, 0.4, -inf];  % merge components with highly correlated spatial shapes (corr=0.8) and small temporal correlations (corr=0.1)
        
        % -------------------------  INITIALIZATION   -------------------------  %
        K = [];             % maximum number of neurons per patch. when K=[], take as many as possible.
        min_corr = 0.4;     % minimum local correlation for a seeding pixel
        min_pnr = 8.5;       % minimum peak-to-noise ratio for a seeding pixel
        min_pixel = (gSig^2);      % minimum number of nonzero pixels for each neuron
        bd = 0;             % number of rows/columns to be ignored in the boundary (mainly for motion corrected data)
        frame_range = [];   % when [], uses all frames
        save_initialization = false;    % save the initialization procedure as a video.
        use_parallel = true;    % use parallel computation for parallel computing
        show_init = true;   % show initialization results
        choose_params = false; % manually choose parameters
        center_psf = true;  % set the value as true when the background fluctuation is large (usually 1p data)
        % set the value as false when the background fluctuation is small (2p)
        
        % -------------------------  Residual   -------------------------  %
        min_corr_res = 0.7;
        min_pnr_res = 6;
        seed_method_res = 'manual';  % method for initializing neurons from the residual
        update_sn = true;
        
        % ----------------------  WITH MANUAL INTERVENTION  --------------------  %
        with_manual_intervention = true;
        
        % -------------------------  FINAL RESULTS   -------------------------  %
        save_demixed = true;    % save the demixed file or not
        kt = 3;                 % frame intervals
        
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
            'bg_ssub', bg_ssub, ...
            'merge_thr', merge_thr, ...             % -------- merging ---------
            'dmin', dmin, ...
            'method_dist', method_dist, ...
            'min_corr', min_corr, ...               % ----- initialization -----
            'min_pnr', min_pnr, ...
            'min_pixel', min_pixel, ...
            'bd', bd, ...
            'center_psf', center_psf);
        neuron.Fs = Fs;
        
        %% *STEP2: LOAD VIDEO DATA*
        %%
        %neuron.options.seed_method  ='manual';
        % distribute data  in blocks and be ready to run source extraction
        neuron.getReady(pars_envs);
        
        [center, Cn, PNR] = neuron.initComponents_parallel(K, frame_range, save_initialization, 1);
        neuron.compactSpatial();
        
        %show intialized seeds.
        if show_init
            figure();
            ax_init= axes();
            imagesc(Cn, [0, 1]); colormap gray;
            hold on;
            plot(center(:, 2), center(:, 1), '.r', 'markersize', 10);
        end
        neuron.PNR=PNR;
        %% *STEP3: Get Peak-to-noise ratio and correlation (can be skipped, but useful to estimate PNS and correlation initialization parameters)*
        %%
        ShowPNS
        
        neuron.update_background_parallel(use_parallel);
        neuron.update_spatial_parallel(use_parallel);
        neuron.update_temporal_parallel(use_parallel);
        cnmfe_path = neuron.save_workspace();
        neuron.merge_neurons_dist_corr(show_merge);
        neuron.merge_high_corr(show_merge, merge_thr_spatial);
        neuron.remove_false_positives();
        
        neuron.update_background_parallel(use_parallel);
        for loop=1:3
            neuron.update_spatial_parallel(use_parallel);
            neuron.update_temporal_parallel(use_parallel);
            neuron.remove_false_positives();
        end
        
        cnmfe_path = neuron.save_workspace();
        
        fix_Baseline(round(40*neuron.Fs),neuron)%% PV
        neuron.C_raw=neuron.C_raw./GetSn(neuron.C_raw);
        neuron.C = deconvTemporal(neuron, use_parallel,1);
        neuron.update_background_parallel(use_parallel);
        neuron.update_temporal_parallel(use_parallel);
        fix_Baseline(round(40*neuron.Fs),neuron)%% PV
        neuron.C_raw=neuron.C_raw./GetSn(neuron.C_raw);
        neuron.C = deconvTemporal(neuron, use_parallel,1);
        neuron.update_background_parallel(use_parallel);
        neuron.update_temporal_parallel(use_parallel);
        fix_Baseline(round(40*neuron.Fs),neuron)%% PV
        neuron.C_raw=neuron.C_raw./GetSn(neuron.C_raw);
        neuron.C = deconvTemporal(neuron, use_parallel,1);
        
        
        cnmfe_path = neuron.save_workspace();
    end
end

%neuron.Coor=[]
%neuron.show_contours(0.3, [], neuron.PNR, 0)
%neuron.show_contours(0.3, [], neuron.Cn, 0)
%neuron.show_contours(0.6, [], neuron.PNR.*neuron.Cn, 0)

%neuron.orderROIs('pnr');   % order neurons in different ways {'snr', 'decay_time', 'mean', 'circularity','sparsity_spatial','sparsity_temporal','pnr'}
%neuron.viewNeurons([], neuron.C_raw);

