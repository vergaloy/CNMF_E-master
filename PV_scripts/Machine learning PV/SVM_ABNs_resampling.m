function out=SVM_ABNs_resampling(mice_sleep)
% out=SVM_ABNs_resampling(mice_sleep);

sim=1000;

out=cell(2,5);

ppm = ParforProgressbar(sim,'showWorkerProgress', true);
D=divide_date_for_SVM(mice_sleep);

parfor i=1:sim
    temp=SVM_ABNs_matrix(divide_date_for_SVM(mice_sleep,D));
    out=arrange_matrix(out,temp);
    ppm.increment();
end    
    
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
    