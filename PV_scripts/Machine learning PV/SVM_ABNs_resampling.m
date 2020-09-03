function out=SVM_ABNs_resampling(mice_sleep)
% out=SVM_ABNs_resampling(mice_sleep);

sim=1000;

out=cell(2,5);
len=1450;
to_svm=kill_inactive_neurons(mice_sleep,len,[8,9]);
to_svm=to_svm(:,[8,9]);
ppm = ParforProgressbar(sim,'showWorkerProgress', true);

parfor i=1:sim
    samplei=random_sample_GCs(to_svm,[24,7,14]); 
    temp=SVM_ABNs_matrix(divide_date_for_SVM(samplei,'random_shifts',[1,2,3],'bin',2,'max_win',295));
    out=arrange_matrix(out,temp);
    ppm.increment();
end    
save(strcat('SVM_sleep_ret',datestr(now,'yymmddHHMMSS'),'.mat'),'out')    
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

    