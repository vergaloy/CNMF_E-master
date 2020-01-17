%%clear all %delte all variables
%% Pre-Sets: These are the user-defined variables.  
clearvars -except neuron test

stimulus_onset=10; %%in s
stimulus_duration=10;
Trial_duration=30;
discard=0;
make_trials=1;
path=neuron.C;


PSTH.Fs=neuron.Fs;
PSTH.frame_range=size(neuron.C,2);
PSTH.C=full(path);
if(path==neuron.S)
PSTH.C(PSTH.C>0)=1;   
end
m=max(PSTH.C(:));
PSTH.C=PSTH.C/m;

trials=(PSTH.frame_range/PSTH.Fs)/(Trial_duration);
trail_data=0;
for t=1:trials
trail_data(PSTH.Fs*((t-1)*Trial_duration+stimulus_onset):PSTH.Fs*((t-1)*Trial_duration+stimulus_onset+stimulus_duration))=1;
end 

BL=PSTH.C;
BL(:,trail_data>0)=[];  
stim=PSTH.C;
stim(:,trail_data==0)=[];  
P=Block_boostrap(BL,stim,1000,10000,2);
