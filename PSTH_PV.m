tic  %Start timer
%%clear all %delte all variables
%% Pre-Sets: These are the user-defined variables.  

clear PSTH
stimulus=120; %%in s
stimulus_off=180;
PSTH.bin_size=20;   %  Bin size in seconds
PSTH.Fs=neuron.Fs;
PSTH.frame_range=neuron.frame_range(2);
PSTH.bin_num=floor(PSTH.frame_range/PSTH.Fs/PSTH.bin_size);
PSTH.bin_frames=PSTH.bin_size*PSTH.Fs;

for n=1:size(neuron.S,1)
for i=1:PSTH.bin_num
temp=double(neuron.S(n,:));
temp(temp>0)=1;
PSTH.S(n,i) = ceil(trapz(temp((i-1)*PSTH.bin_frames+1:i*PSTH.bin_frames)))/PSTH.bin_size;
end
end




PSTH.Total=sum(PSTH.S,1)/size(neuron.S,1);
x =(-stimulus:PSTH.bin_size:(PSTH.bin_num-(stimulus/PSTH.bin_size)-1)*PSTH.bin_size);
b=bar(x,PSTH.Total,'histc');
set(b,'FaceColor','k')
xticks(-120:30:180)
