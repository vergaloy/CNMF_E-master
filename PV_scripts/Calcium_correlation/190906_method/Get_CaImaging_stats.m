%%Preparate data
justdeconv;   %deconvolve the raw calcium signal
[FC.E,FC.W,FC.H,~,FC.Ordered]=functional_connectivty(neuron.S,neuron.C,3);
temp=neuron.S;
temp(temp>0)=1;
sleepdata=separate_by_sleep(neuron.S,hypno);
H_Sleep=separate_by_sleep(FC.H./max(FC.H,[],2),hypno);
export_fig Results.pdf -append;
disp('Total cells, pattern cells,  ')
temp=FC.W;
temp=sum(temp,2);
temp(temp>0)=1;
temp=logical(temp);
[size(temp,1),sum(temp,1)]
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
patterns=get_centroids(neuron.Coor(temp),neuron.S(temp,:));
no_patterns=get_centroids(neuron.Coor(~temp),neuron.S(~temp,:));
patterns(:,1)
no_patterns(:,1)
disp('patterns vs no-patterns activty, W-RW-REM-NREM')
patterns=[mean(sleepdata.wake(temp,:),2),mean(sleepdata.rw(temp,:),2),mean(sleepdata.rem(temp,:),2),mean(sleepdata.nrem(temp,:),2)]
no_patterns=[mean(sleepdata.wake(~temp,:),2),mean(sleepdata.rw(~temp,:),2),mean(sleepdata.rem(~temp,:),2),mean(sleepdata.nrem(~temp,:),2)]
export_fig Results.pdf -append;
