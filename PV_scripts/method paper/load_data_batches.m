function out=load_data_batches()
% batches=load_data_batches()
dir= uigetdir;
n=29;
for i=1:29
    i
    file=strcat(dir,'\batch',num2str(i),'.mat');
    if isfile(file)
    out{i,1}=load(file,'neuron');
    else
        out{i,1}=[];  
    end    
end