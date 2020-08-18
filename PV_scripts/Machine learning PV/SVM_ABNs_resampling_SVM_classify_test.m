function [test_svm,shift_svm,random_svm]=SVM_ABNs_resampling_SVM_classify_test(mice_sleep)
% [test_svm,shift_svm,random_svm]=SVM_ABNs_resampling_SVM_classify_test(mice_sleep);

sim=1000;

test_svm=zeros(3,6);
shift_svm=zeros(3,6);
random_svm=zeros(3,6);
 ppm = ParforProgressbar(sim,'showWorkerProgress', true);

parfor i=1:sim
    [test,shift,r]=SVM_classify_test(mice_sleep);
    test_svm=cat_matrix(test_svm,test);
    shift_svm=cat_matrix(shift_svm,shift);
    random_svm=cat_matrix(random_svm,r);
    ppm.increment();
end  
test_svm(:,:,1)=[];
shift_svm(:,:,1)=[];
random_svm(:,:,1)=[];
save(strcat('SVM_classify_inside',datestr(now,'yymmddHHMMSS'),'.mat'),'test_svm','shift_svm','random_svm')
     
 delete(ppm); 

end

function out=cat_matrix(out,t)
out=cat(3,out,t);
end    