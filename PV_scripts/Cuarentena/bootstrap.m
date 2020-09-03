function CI=bootstrap(obj,c)
% CI=bootstrap(pro,0);
sims=1000;
col=size(obj,2);
sim=zeros(sims,col);

for s=1:sims
    for i=1:col
        temp=obj(:,i);
        temp(isnan(temp))=[];
        temp=datasample(temp,size(temp,1));
        sim(s,i)= mean(temp);
    end
end

[nanmean(obj,1)',prctile(sim,97.5,1)',prctile(sim,2.5,1)']

if (size(obj)>1)
    b=nchoosek(1:col,2);
    CI=zeros(col);
    comp=size(b,1);
    if (c==0)
        c=comp;
    end
    alpha=5/c/2;
    for i=1:comp
        t1=sim(:,b(i,1));
        t2=sim(:,b(i,2));
        CI(b(i,1),b(i,2))=(prctile(t1-t2,alpha)*prctile(t1-t2,100-alpha))>0;
    end
    CI=CI+CI'
    
end