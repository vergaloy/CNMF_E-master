function [Y]=MS_bootstrap_activity(obj,hypno)
% [Y]=MS_bootstrap_activity(neuron.S,hypno);
clear textprogressbar

MS=get_overlaping_cell_MS(obj,hypno);
opts = statset('MaxIter',1000);
[X,stress,disparities]=mdscale(MS,2,'Criterion','stress','Options',opts);
Shepard_Plot(sqrt(1-MS),X,disparities,0);
stress
X=X(:,1:2);
Y=X-mean(X);






