function [CI,P,CIc]=bootstrap_sum(obj,c,method)

% [CI,P]=bootstrap(A,2);

if ~exist('method','var')  
 method='percentiles';   
end

if ~exist('c','var')  
 c=size(obj,2);  
end

alpha=5/c/2;
% CI=bootstrap(pro,0);
sims=1000;
col=size(obj,2);
sim=zeros(sims,col);

parfor s=1:sims
    for i=1:col
        temp=obj(:,i);
        temp(isnan(temp))=[];
        temp=datasample(temp,size(temp,1));
        sim(s,i)= sum(temp);
    end
end

CI=[nansum(obj,1)',prctile(sim,97.5,1)',prctile(sim,2.5,1)'];
CIc=[nansum(obj,1)',prctile(sim,100-alpha,1)',prctile(sim,alpha,1)'];

switch method
    
    case 'percentiles'
        if (size(obj)>1)
            b=nchoosek(1:col,2);
            P=zeros(col);
            comp=size(b,1);    
            for i=1:comp
                t1=sim(:,b(i,1));
                t2=sim(:,b(i,2));
                P(b(i,1),b(i,2))=(prctile(t1-t2,alpha)*prctile(t1-t2,100-alpha))>0;
            end
            P=P+P';
        end
    case 'normal'
        if (size(obj)>1)
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