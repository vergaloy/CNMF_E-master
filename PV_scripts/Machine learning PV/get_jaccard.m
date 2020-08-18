function [S,R]=get_jaccard(mice_sleep)
sim=1000;
S=zeros(size(mice_sleep,2),size(mice_sleep,2),sim);
R=zeros(size(mice_sleep,2),size(mice_sleep,2),sim);
ppm = ParforProgressbar(sim,'showWorkerProgress', true);
parfor i=1:sim
    D=divide_date_for_SVM(mice_sleep,'random_shifts',[1,2,3,4,5,6,7,8,9],'w_size',145);
    out=get_no_zero(D)
    S(:,:,i)=squareform(pdist(out','jaccard'));
    ran=random_columns(out)
    R(:,:,i)=squareform(pdist(ran','jaccard'));
    ppm.increment();
end
delete(ppm); 
end

function out=get_no_zero(D)
    for i=1:size(D,2)
        temp=D{1, i};
        temp(temp>0)=1;
        for s=1:1000
            surr=datasample(temp,size(temp,2),2);
            T(:,i,s)=nanmean(surr,2);
        end
    end
    
    out=prctile(T,5,3);
    out=out>0;
    
end

function out=random_columns(out)
n=size(out,1);
for i=1:size(out,2)
    out(:,i)=out(randperm(n),i);
end
end



