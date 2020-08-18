data=load_mice_data();  %load data
[mice_sleep,hyp]=group_mice_data(data);  %separate data by behaviour
D=divide_date_for_SVM(mice_sleep);   
D=divide_date_for_SVM(mice_sleep,'random_shifts',[1,2,3,4,5,6,7,8,9],'w_size',0,'kill_zero',1);
out=SVM_ABNs_resampling(mice_sleep);

% Or

out=SVM_ABNs_resampling_TestvsTrain(mice_sleep);
