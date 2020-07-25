function out=SVM_ABNs_resampling_TestvsTrain(mice_sleep)
% out=SVM_ABNs_resampling_TestvsTrain(mice_sleep);

sim=1000;

out=cell(1,5);

 ppm = ParforProgressbar(sim,'showWorkerProgress', true);

parfor i=1:sim
    temp=TestvsTrain(mice_sleep);
    out=arrange_matrix(out,temp);
    ppm.increment();
end  

 save(strcat('SVM_TvT_',datestr(now,'yymmddHHMMSS'),'.mat'),'out')
     
 delete(ppm); 

end

function out=arrange_matrix(out,temp)

for i=1:5
    out{1,i}=cat(3,out{1,i},temp{1,i});
end

end
    