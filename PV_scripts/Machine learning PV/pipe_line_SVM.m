data=load_mice_data();  %load data
[mice_sleep,hyp]=group_mice_data(data);  %separate data by behaviour
D=divide_date_for_SVM(mice_sleep);     
out=SVM_ABNs_resampling(mice_sleep);

% Or

out=SVM_ABNs_resampling_TestvsTrain(mice_sleep);
