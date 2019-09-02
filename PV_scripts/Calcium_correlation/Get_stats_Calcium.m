%%Preparate data
justdeconv;   %deconvolve the raw calcium signal
sleepdata=separate_by_sleep(neuron.C,hypno);     %separate the C signal in sleep stages, require a
file "hypno" with the sleep data, 0=wake, 0.5=NREM  1=REM, negative
=artifact
disp('Deconvolving traces and sorting by sleep stage..Ok')
%% Bin data
binsize=5;
sf=5.02;
[sleepdata.bin.wake_burst,~,sleepdata.bin.twake]=binndata(sleepdata.wake,binsize,sf,1,1);
[sleepdata.bin.wake_bin,~,sleepdata.bin.twake]=binndata(sleepdata.wake,binsize,sf,0,0);
[sleepdata.bin.nrem_burst,~,sleepdata.bin.tnrem]=binndata(sleepdata.nrem,binsize,sf,1,1);
[sleepdata.bin.rem]=binndata(sleepdata.rem,binsize,sf,0,0);
sleepdata.bin.all = [sleepdata.bin.wake, sleepdata.bin.nrem];
sleepdata.bin.all_noSD = [binndata(sleepdata.wake,binsize,sf,0,0), binndata(sleepdata.nrem,binsize,sf,0,0)];
disp('Binning Data...Ok')
%% Get Correlation vs neuronal distance
neuron.Coor=[];
neuron.show_contours(0.6, [], neuron.PNR, false);
[sleepdata.coor.DvR]=get_centroids(neuron.Coor,sleepdata.bin.all);
disp('Correlation vs neuronal distance...Ok')
%% Get correlations of patterns
[sleepdata.cor.wake,~]=corrmatrix(sleepdata.bin.wake);
[sleepdata.cor.nrem,~]=corrmatrix(sleepdata.bin.nrem);
[sleepdata.cor.all,~]=corrmatrix(sleepdata.bin.all);
disp('Correlation of patterns...Ok')
%% get PVD
[sleepdata.cor.wake_PVD,sleepdata.cor.wake_sumcorr,sleepdata.cor.wake_sumcorr_P]=PVD_self(sleepdata.bin.wake);
[sleepdata.cor.nrem_PVD,sleepdata.cor.nrem_sumcorr,sleepdata.cor.nrem_sumcorr_P]=PVD_self(sleepdata.bin.nrem);
disp('Population vector distance (PVD)...Ok')

%% NMF
[sleepdata.nmf.nrem.W,sleepdata.nmf.nrem.H]=NMF_prune(sleepdata.bin.nrem);
[sleepdata.nmf.wake.W,sleepdata.nmf.wake.H]=NMF_prune(sleepdata.bin.wake);
[sleepdata.nmf.all.W,sleepdata.nmf.all.H]=NMF_prune(sleepdata.bin.all);
[sleepdata.nmf.dot_matrix,sleepdata.nmf.ms]=get_MS(sleepdata.nmf.wake.W,sleepdata.nmf.nrem.W);
[sleepdata.nmf.dot_matrix,sleepdata.nmf.ms_WvR]=get_MS(sleepdata.nmf.wake.W,sleepdata.bin.rem);
[sleepdata.nmf.dot_matrix,sleepdata.nmf.ms_NvR]=get_MS(sleepdata.nmf.nrem.W,sleepdata.bin.rem);
sleepdata.nmf.wakeHcorr=patter_corr(sleepdata.nmf.wake.H');
sleepdata.nmf.nremHcorr=patter_corr(sleepdata.nmf.nrem.H');
disp('Non-negative matrix factorization...Ok')