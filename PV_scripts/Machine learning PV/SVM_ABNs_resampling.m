function out=SVM_ABNs_resampling(mice_sleep)
% out=SVM_ABNs_resampling(mice_sleep);

sim=1000;

out=cell(2,5);

ppm = ParforProgressbar(sim,'showWorkerProgress', true);

parfor i=1:sim
    temp=SVM_ABNs_matrix(divide_date_for_SVM(mice_sleep,'max_win',100,'kill_zero',1,'random_shifts',[1,2,3,4,5,6,7,8,9]));
    out=arrange_matrix(out,temp);
    ppm.increment();
end    
save(strcat('SVM_',datestr(now,'yymmddHHMMSS'),'.mat'),'out')    
delete(ppm); 

end

function out=arrange_matrix(out,temp)

for i=1:5
    out{1,i}=cat(3,out{1,i},temp{1,i});
    if (~isempty(out{2,i}))
    out{2,i}=out{2,i}+temp{2,i};
    else
      out{2,i}=temp{2,i};   
    end
end

end
    