function [out,pattern]=make_spikes(N,T,P,PC,PF,F,SB,NF)  %T=length firerate=frequency  fb=frequency during burst NF=non-pattern frequency
%out=make_spikes(35,55000,4,[5],0.006,0.008,0.001,0.002);
w=50;
[out,pattern]=NMF_simulated_data(N,T,P,PC,PF,F,NF);
in=out;
for t=1:T-w-1
    out(:, t+1:t+w) = out(:,t+1:t+w)+out(:, t)*(poissrnd(0.4,1,w)).*(rand(1,w)<poisspdf(1:w,20));
end
