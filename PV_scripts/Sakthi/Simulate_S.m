function [C]=Simulate_S()
%   [C]=Simulate_S();
%% MODEL parameters
neuron_num=15;
frames=3000;
log_amp=0.6;  %logaritm of mean amplitude
log_SD=0.2; %logaritm of std
non_zero_prob=0.0027;

sf=10;
bin_size=2;
bin_shift=1;

nonzero_cov_prob=0.5;

%% modelate amplitude of active cells
mean_amp =random('HalfNormal',log_amp,log_SD,neuron_num,1); %random mean amplitude for each neuron
cov_m = randcov(neuron_num,nonzero_cov_prob,log_SD);  %create random covariance matrix

%% Simulate Training
activity = exp(mvnrnd(mean_amp,cov_m,frames)'); %create random multivariate exponentially distributed data

eP =ones(neuron_num,1)*lognrnd(log(non_zero_prob),1.5,[1,frames]);
eP(eP>1)=1;
R=binornd(1,eP,neuron_num,frames);
C{1}= moving_mean(activity.*R,sf,bin_size,bin_shift,0);
%% simulate context A using same average activity and covariance matrix
activity = exp(mvnrnd(mean_amp,cov_m,frames)'); %create random multivariate exponentially distributed data
eP =ones(neuron_num,1)*lognrnd(log(non_zero_prob),1.5,[1,frames]);
eP(eP>1)=1;
R=binornd(1,eP,neuron_num,frames);
C{2}= moving_mean(activity.*R,sf,bin_size,bin_shift,0);
%% simulate context C using new randomly generated average activity and covariance matrix
mean_amp =normrnd(log_amp,log_SD,neuron_num,1); %random mean amplitude for each neuron
cov_m = randcov(neuron_num,nonzero_cov_prob,log_SD);  %create random covariance matrix

activity = exp(mvnrnd(mean_amp,cov_m,frames)'); %create random multivariate exponentially distributed data
eP =ones(neuron_num,1)*lognrnd(log(non_zero_prob),1.5,[1,frames]);
eP(eP>1)=1;
R=binornd(1,eP,neuron_num,frames);
C{3}= moving_mean(activity.*R,sf,bin_size,bin_shift,0);

