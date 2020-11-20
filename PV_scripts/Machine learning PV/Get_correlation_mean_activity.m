function [r,p]=Get_correlation_mean_activity(mice_sleep,conditions,values)


if ~exist('conditions','var')
    conditions=[1,2,3,4,5,6,7,8,9];
end

if ~exist('values','var')
     values={'HC','preS','postS','REM','HT','LT','N','A','C'};
end


[D,a]=bin_mice_sleep(mice_sleep,conditions,2);
%%
% a=a./max(a,[],2);
t=zscore(a')';
% This is very important to interpret the results
% here we normalized the activty of each cell first across different
% session. Then we normalize relative to the activity in each condition.
% if we normalize across sessions first, clustering will be biassed to the
% differences in activity  between sessions. If we dont, clustering will be
% biased towards the absulut activties of neurons, no matter the activity
% in other sessions. 
%%
% dis = squareform(pdist(t','Correlation'));
[r,p]=corr(t);
p=p+diag(ones(1,size(p,2)));

plot_heatmap_PV(r,p,values,'Correlation','money')

