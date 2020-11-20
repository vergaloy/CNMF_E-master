function [CId]=bootstrap_dif_ratio(obj1,obj2,c)


alpha=5/c/2;
sims=1000;
col=size(obj1,2);
sim=zeros(sims,col);

parfor s=1:sims
    for i=1:col
        temp=obj1(:,i);
        temp(isnan(temp))=[];
        temp=datasample(temp,size(temp,1));
        x1=mean(temp);
        temp=obj2(:,i);
        temp(isnan(temp))=[];
        temp=datasample(temp,size(temp,1));
        x2=mean(temp);
        sim(s,i)= x1-x2;
    end
end
CId=[nanmean(obj1,1)'-nanmean(obj2,1)',prctile(sim,100-alpha,1)',prctile(sim,alpha,1)'];
end