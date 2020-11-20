% data=load_mice_data();  %load data
% [mice_sleep,hyp]=group_mice_data(data);  %separate data by behaviour


function out=SVM_ABNs_resampling_mix_contexts(mice_sleep)
% out=SVM_ABNs_resampling_mix_contexts(mice_sleep);

sim=1000;
ref=[8,1,9];
out=cell(2,5);
len=1450;
to_svm=kill_inactive_neurons(mice_sleep,len,ref);
to_svm=to_svm(:,[ref(1),ref(2),ref(3)]);

 ppm = ParforProgressbar(sim,'showWorkerProgress', true);

parfor i=1:sim
    sample=mix_context(to_svm);  
    temp=SVM_ABNs_matrix(divide_date_for_SVM(sample,'random_shifts',[1,2,3,4,5,6,7,8,9],'bin',2,'max_win',295));
    out=arrange_matrix(out,temp);
    ppm.increment();
end    
save(strcat('SVM_HCandCvsA',datestr(now,'yymmddHHMMSS'),'.mat'),'out')    
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

function out=mix_context(data)

out=data(:,1:2);
for i=1:size(data,1)
        temp=data(i,2:3);
        temp=catpad(2,temp{:});
        out{i,2}=datasample(temp,size(data{i,1},2),2);
end
end



    