%%Preparate data
neuron=justdeconv(neuron);   %deconvolve the raw calcium signal
temp=neuron.S;
temp(temp>0)=1;
[FC.E,FC.W,FC.H,~,pat_cells]=functional_connectivty(temp,temp,3,1);
FC.patcells=neuron.S(pat_cells,:);
FC.nonpatcells=neuron.S(~pat_cells,:);


sleepdata=separate_by_sleep(temp,hypno);
H_Sleep=separate_by_sleep(FC.H./max(FC.H,[],2),hypno);
export_fig Results.pdf -append;
disp('Total cells, pattern cells,  ')
[size(pat_cells,1),sum(pat_cells,1)]
disp('# of patterns, Cells/patterns')
ti=FC.W;
ti(ti>0)=1;
size(FC.H ,1)
sum(ti,1)'
disp('Pattern activity  WAKE RW REM NREM')
[mean(H_Sleep.wake,2),mean(H_Sleep.rw,2),mean(H_Sleep.rem,2),mean(H_Sleep.nrem,2)]

[FC.H_corr,~]=corrmatrix(FC.H');
disp('Calcium Activity  WAKE RW REM NREM')
[mean(sleepdata.wake  ,2),mean(sleepdata.rw,2),mean(sleepdata.rem,2),mean(sleepdata.nrem,2)].*neuron.Fs
disp('Patterns correlation')
squareform(FC.H_corr-diag(diag(FC.H_corr)),'tovector')'
disp('Burst Activity  WAKE')
[T,lags]=Get_burst(temp);
M=moving_mean(temp,neuron.Fs,8,1/neuron.Fs,0);
M=round(M*neuron.Fs*8);




export_fig Results.pdf -append;

%% Get Correlation vs neuronal distance
neuron.Coor=[];
neuron.show_contours(0.6, [], neuron.PNR, false);
export_fig Results.pdf -append;
[sleepdata.coor.DvR]=get_centroids(neuron.Coor,neuron.S);
disp('Correlation vs neuronal distance')
sleepdata.coor.DvR
figure
scatter(sleepdata.coor.DvR(:,1),sleepdata.coor.DvR(:,2));
disp('patterns vs no-patterns distance')
patterns=get_centroids(neuron.Coor(pat_cells),neuron.S(pat_cells,:));
no_patterns=get_centroids(neuron.Coor(~pat_cells),neuron.S(~pat_cells,:));
patterns(:,1)
no_patterns(:,1)
disp('patterns vs no-patterns activty, W-RW-REM-NREM')
patterns=[mean(sleepdata.wake(pat_cells,:),2),mean(sleepdata.rw(pat_cells,:),2),mean(sleepdata.rem(pat_cells,:),2),mean(sleepdata.nrem(pat_cells,:),2)]
no_patterns=[mean(sleepdata.wake(~pat_cells,:),2),mean(sleepdata.rw(~pat_cells,:),2),mean(sleepdata.rem(~pat_cells,:),2),mean(sleepdata.nrem(~pat_cells,:),2)]
export_fig Results.pdf -append;
