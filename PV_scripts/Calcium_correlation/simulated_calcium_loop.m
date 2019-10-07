function [spike_R]=simulated_calcium_loop(neuron)
tic
%[spike_R,N_pattern,MS_mymethod,MS_inokuchi]=simulated_calcium_loop(neuron);
sims=1;

spike_R(1:sims,1:40)=0;
for i=1:sims
    [Y,~, trueS,~]=Simulated_calcium_trace();
    neuron.C_raw=Y;
    neuron=justdeconv(neuron);
    mS=neuron.S;
    mS(mS>0)=1;
    
    for r=1:40
        k=trueS.*moving_mean(mS,5,r/5,1/5,0);
        k(k>0)=1;
        R=corrcoef(k,trueS);
        spike_R(i,r)=R(1,2);
    end
end
toc



