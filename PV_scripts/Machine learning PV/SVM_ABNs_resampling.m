function out=SVM_ABNs_resampling(mice_sleep)
% SVM=SVM_ABNs_resampling(mice_sleep);

sim=1000;
ref=[1,2];
out=cell(2,5);
% len=1450;
% to_svm=kill_inactive_neurons(mice_sleep,len,ref);
% to_svm=to_svm(:,ref);
to_svm=mice_sleep(:,ref);
 ppm = ParforProgressbar(sim,'showWorkerProgress', true);

parfor i=1:sim
%     samplei=random_sample_GCs(to_svm,[37,14,14]); 'max_win',295
    temp=SVM_ABNs_matrix(divide_date_for_SVM(to_svm,'random_shifts',[1,2,3,4,5,6,7,8,9],'sf',1,'bin',1,'max_win',295));
    out=arrange_matrix(out,temp);
    ppm.increment();
end    
save(strcat('SVM_all_reduced',datestr(now,'yymmddHHMMSS'),'.mat'),'out')    
delete(ppm); 

end

function out=arrange_matrix(out,temp)

for i=1:size(out,2)
    if(~isempty(out{1, i}))
    out{1,i}=catpad(3,out{1,i},temp{1,i});
    out{2,i}=catpad(4,out{2,i},temp{2,i});
    else
    out{1,i}=temp{1,i};
    out{2,i}=temp{2,i};  
    end
end

end

function sample=random_sample_GCs(data,num)
sample=cell(size(data,1),size(data,2));

for i=1:size(data,1)
    k=num(i);
    for j=1:size(data,2)
        sample{i,j}=datasample(data{i,j},k,1);
    end
end
end

    