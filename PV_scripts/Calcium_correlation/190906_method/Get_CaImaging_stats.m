function Get_CaImaging_stats(neuron,hypno,nombre)
%%Preparate data
%neuron=justdeconv(neuron);   %deconvolve the raw calcium signal
temp=neuron.S;
temp(temp>0)=1;
temp_bin=bin_data(temp,round(neuron.Fs),2,1/round(neuron.Fs),0);

log=strcat(nombre,'.txt');
pdfile=strcat(nombre,'.pdf');
diary(log)


%% Activity stats
sleepdata=separate_by_sleep(temp,hypno);
sleepdata.bin=separate_by_sleep(temp_bin,hypno);
disp('Calcium Activity  WAKE RW REM NREM')
[mean(sleepdata.wake,2),mean(sleepdata.rw,2),mean(sleepdata.rem,2),mean(sleepdata.nrem,2)].*neuron.Fs

[~,~,~]=Get_burst(temp_bin,neuron.Fs,1);
export_fig(pdfile, '-append');
disp('Burst Activity Wake')
[~,~,burst_rate]=Get_burst(sleepdata.wake,neuron.Fs,0);
disp('====Spikes per Burst====')
disp('1 2 3 4 5 6 7 8 9 10') 
burst_rate
disp('Burst Activity high-theta')
[~,~,burst_rate]=Get_burst(sleepdata.rw,neuron.Fs,0);
disp('====Spikes per Burst====')
disp('1 2 3 4 5 6 7 8 9 10')
burst_rate
disp('Burst Activity REM')
[~,~,burst_rate]=Get_burst(sleepdata.rem,neuron.Fs,0);
disp('====Spikes per Burst====')
disp('1 2 3 4 5 6 7 8 9 10')
burst_rate
disp('Burst Activity NREM')
[~,~,burst_rate]=Get_burst(sleepdata.nrem,neuron.Fs,0);
disp('====Spikes per Burst====')
disp('1 2 3 4 5 6 7 8 9 10')
burst_rate


%%
%pattern Stats

[FC.E,FC.W,FC.H,~,pat_cells]=functional_connectivty(temp_bin,temp_bin,3,1);
FC.patcells=neuron.S(pat_cells,:);
FC.nonpatcells=neuron.S(~pat_cells,:);
H_Sleep=separate_by_sleep(FC.H./max(FC.H,[],2),hypno);
export_fig(pdfile, '-append');

disp('Total cells, pattern cells,  ')
[size(pat_cells,1),sum(pat_cells,1)]
disp('# of patterns')
ti=FC.W;
ti(ti>0)=1;
size(FC.H ,1)
disp('Cells/patterns')
sum(ti,1)'
disp('Pattern activity  WAKE RW REM NREM')
[mean(H_Sleep.wake,2),mean(H_Sleep.rw,2),mean(H_Sleep.rem,2),mean(H_Sleep.nrem,2)]

disp('Patterns correlation')
[FC.H_corr,~]=corrmatrix(FC.H',0);
squareform(FC.H_corr-diag(diag(FC.H_corr)),'tovector')'



%% Get Correlation vs neuronal distance
neuron.Coor=[];
neuron.show_contours(0.6, [], neuron.PNR, false);
export_fig(pdfile, '-append');
[sleepdata.coor.DvR]=get_centroids(neuron.Coor,temp_bin);
disp('Correlation vs neuronal distance')
sleepdata.coor.DvR
figure
scatter(sleepdata.coor.DvR(:,1),sleepdata.coor.DvR(:,2));
disp('patterns vs no-patterns distance')
patterns=get_centroids(neuron.Coor(pat_cells),temp_bin(pat_cells,:));
no_patterns=get_centroids(neuron.Coor(~pat_cells),temp_bin(~pat_cells,:));
patterns(:,1)
no_patterns(:,1)
disp('patterns vs no-patterns activty, W-RW-REM-NREM')
patterns=[mean(sleepdata.wake(pat_cells,:),2),mean(sleepdata.rw(pat_cells,:),2),mean(sleepdata.rem(pat_cells,:),2),mean(sleepdata.nrem(pat_cells,:),2)]
no_patterns=[mean(sleepdata.wake(~pat_cells,:),2),mean(sleepdata.rw(~pat_cells,:),2),mean(sleepdata.rem(~pat_cells,:),2),mean(sleepdata.nrem(~pat_cells,:),2)]
export_fig(pdfile, '-append');
diary('off')
