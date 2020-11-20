% Specify the folder where the files live.
myFolder ='C:\Users\BigBrain\Desktop\test\DM95-Objects';  %Write the path with the
filePattern = fullfile(myFolder, '*.h5'); % Change to whatever pattern you need.
theFiles = dir(filePattern);


for k=1:length(theFiles)
    clearvars -except filePattern theFiles k myFolder
    close all
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    %% Constrained Nonnegative Matrix Factorization for microEndoscopic data  * *
    % *STEP*0: select data
    warning('off','all');
    neuron = Sources2D();
    nams = {fullFileName};          % this demo data is very small, here we just use it as an example
    nams = {neuron.select_multiple_files(nams)};  %if nam is [], then select data interactively
    
    %% parameters
    % -------------------------    COMPUTATION    -------------------------  %
    pars_envs = struct('memory_size_to_use', 256, ...   % GB, memory space you allow to use in MATLAB
        'memory_size_per_patch', 65, ...   % GB, space for loading data within one patch
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
% Note: We recomend using an ar1 foopsi model to update the temporal components (is faster, and sometime ar2 models crush). 
% Once you have extracted the calcium signal you can deconvolve the calcium traces
% using a different model (i.e thresholded ar2).
    
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
    bg_ssub = 1;        % downsample background for a faster speed. not working for batch mode
    % -------------------------      MERGING      -------------------------  %
    show_merge = false;  % if true, manually verify the merging step
    merge_thr = 0.65;     % thresholds for merging neurons; [spatial overlap ratio, temporal correlation of calcium traces, spike correlation]
    method_dist = 'max';   % method for computing neuron distances {'mean', 'max'}
    dmin = 5;       % minimum distances between two neurons. it is used together with merge_thr
    dmin_only = 2;  % merge neurons if their distances are smaller than dmin_only.
    merge_thr_spatial = [0.8, 0.4, -inf];  % merge components with highly correlated spatial shapes (corr=0.8) and small temporal correlations (corr=0.1)
    
    % -------------------------  INITIALIZATION   -------------------------  %
    K = [];             % maximum number of neurons per patch. when K=[], take as many as possible.
    min_corr = 0.8;     % minimum local correlation for a seeding pixel
    min_pnr = 8;       % minimum peak-to-noise ratio for a seeding pixel
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
    min_pnr_res = 7;
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
    standarize_C_raw(neuron) 
    %% get the correlation image and PNR image for all neurons
    neuron.correlation_pnr_batch();
    [neuron.PNR_all,neuron.Cn_all]=create_PNR_batch(neuron);
    %% concatenate temporal components of each batch
    concatenate_shifted_batch(neuron);
    neuron.P=neuron.batches{1, 1}.neuron.P;
    neuron.frame_range=[1,size(neuron.C_raw,2)];
    
    neuron=justdeconv(neuron,'foopsi','ar2'); % you can change this to foopsi   
    fix_Baseline(round(40*neuron.Fs),neuron)%% PV this may not be necessary, but can be useful to correct for slow fluctuation in the calcium traces when recordings are very long
    %sometimes it decrease the amount of false-positives spikes. 
    

    scale_to_noise(neuron,500); %this is to fix the differences in the basline noise level across batches.
    neuron=justdeconv(neuron,'foopsi','ar2');

    neuron.merge_neurons_dist_corr(0);
    neuron.merge_high_corr(0, [0.6, -1, -inf]);
    
    for i=1:3 %Running this may fix problems ralated to shifts in baseline noise across batches
    scale_to_noise(neuron,200); 
    neuron=justdeconv(neuron,'foopsi','ar2');
    end

    neuron.orderROIs('snr'); 
    %% save workspace
    neuron.P.log_folder=strcat(neuron.P.folder_analysis,filesep);
    neuron.P=neuron.batches{1, 1}.neuron.P;
    get_frame_ranges(neuron);
    
    neuron.save_workspace_batch();  %save batch data
    fclose('all');
    neuron.batches=0;  %kill batch data, it is not necessary to laod it again
    
    neuron.P.log_folder=strcat(neuron.P.folder_analysis,filesep);
    cnmfe_path = neuron.save_workspace();   
end

%% USEFULL COMMANDS

%%  To manually inspect spatial and temporal components of each neuron
%   neuron.orderROIs('snr');   % order neurons in different ways {'snr', 'decay_time', 'mean', 'circularity','sparsity_spatial','sparsity_temporal','pnr'}
%   neuron.viewNeurons([], neuron.C_raw); 

%% To save results in a new path run these lines a choose the new folder:
%   neuron.P.log_file=strcat(uigetdir,filesep,'log_',date,'.txt');
%   neuron.P.log_folder=strcat(uigetdir,'\'); %update the folder
%   cnmfe_path = neuron.save_workspace();   
%% To visualize neurons contours:
%   neuron.Coor=[]
%   neuron.show_contours(0.6, [], neuron.PNR, 0)  %PNR
%   neuron.show_contours(0.6, [], neuron.Cn, 0)   %CORR
%   neuron.show_contours(0.9, [], neuron.PNR.*neuron.Cn, 0); %PNR*CORR
%% normalized spatial components 
% A=neuron.A;A=full(A./max(A,[],1)); A=reshape(max(A,[],2),[size(neuron.Cn,1),size(neuron.Cn,2)]);
% neuron.show_contours(0.6, [], A, 0);
%% To visualize the PNR and CORR in each batch
%   implay(cat(2,mat2gray(neuron.PNR_all),mat2gray(neuron.Cn_all)),5);

%% to visualize all temporal traces
%   strips(neuron.C_raw');   
%   stackedplot(neuron.C_raw');  

%% Manually merge very close neurons
% neuron.merge_high_corr(1, [0.5, -1, -inf]);



