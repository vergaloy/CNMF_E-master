function [spike_R,spike_Rnorm]=simulated_calcium_loop(neuron)
tic
%[spike_R,spike_Rnorm]=simulated_calcium_loop(neuron);
sims=1;

spike_R(1:sims,1:40)=0;
spike_Rnorm(1:sims,1:40)=0;
for i=1:sims
    [Y,~, trueS,~]=Simulated_calcium_trace();
    neuron.C_raw=Y;
    neuron=justdeconv(neuron);
    mS=neuron.S;
    
    for r=1:40
        R=corrcoef(moving_mean(mS,5,r/5,1/5,0),moving_mean(trueS,5,r/5,1/5,0));
        spike_R(i,r)=R(1,2);
    end
    trueS(trueS>0)=1;
    mS(mS>0)=1;
    for r=1:40
        R=corrcoef(moving_mean(mS,5,r/5,1/5,0),moving_mean(trueS,5,r/5,1/5,0));
        spike_Rnorm(i,r)=R(1,2);
    end
end
toc



