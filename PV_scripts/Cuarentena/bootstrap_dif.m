function [P,CI]=bootstrap_dif(obj1,obj2,c,method)


if ~exist('method','var')  
 method='percentiles'  
end

sims=1000;
col=size(obj1,2);
sim=zeros(sims,col);



for i=1:col
    temp1=obj1(:,i);
    temp1(isnan(temp1))=[];
    temp2=obj2(:,i);
    temp2(isnan(temp2))=[];
    surr=[temp1,temp2];
    parfor s=1:sims
        temp=datasample(surr,size(surr,1));
        sim(s,i)= mean(temp(:,1),1)./mean(temp(:,2),1);
    end
    clear surr
end

CI=[nanmean(sim,1)',prctile(sim,97.5,1)',prctile(sim,2.5,1)']


switch method
    
    case 'percentiles'
        if (size(obj1)>1)
            b=nchoosek(1:col,2);
            P=zeros(col);
            comp=size(b,1);
            if (c==0)
                c=comp;
            end
            alpha=5/c/2;
            for i=1:comp
                t1=sim(:,b(i,1));
                t2=sim(:,b(i,2));
                P(b(i,1),b(i,2))=(prctile(t1-t2,alpha)*prctile(t1-t2,100-alpha))>0;
            end
            P=P+P';
        end
    case 'normal'
        if (size(obj1)>1)
            b=nchoosek(1:col,2);
            comp=size(b,1);
            for i=1:comp
                t=sim(:,b(i,1))-sim(:,b(i,2));
                m=abs(0-mean(t))./std(t);
                p(i)=2*normcdf(-m);
            end
            
            [~,~,~,p]=fdr_bh(p);
            P=1-squareform(1-p);
        end
        
end

end