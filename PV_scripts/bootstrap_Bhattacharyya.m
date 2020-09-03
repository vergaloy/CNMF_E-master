function CI=bootstrap_Bhattacharyya(obj,c)
% CI=bootstrap_Bhattacharyya(G,2)

[nanmean(obj,1)',prctile(obj,97.5,1)',prctile(obj,2.5,1)']
col=size(obj,2);
if (size(obj,2)>1)
    b=nchoosek(1:col,2);
    CI=zeros(col);
    comp=size(b,1);
    if (c==0)
        c=comp;
    end
    alpha=0.05/c;
    for i=1:comp
        t1=obj(:,b(i,1));
        t2=obj(:,b(i,2));
        [B,~]=Bhattacharyya_coefficient_1D(t1,t2);
        CI(b(i,1),b(i,2))=B<alpha;
    end
    CI=CI+CI';   
end
end


function [B,DB]=Bhattacharyya_coefficient_1D(A,B)
m1=mean(A);
m2=mean(B);
v1=var(A);
v2=var(B);
DB=0.25*log(0.25.*(v1./v2+v2./v1+2))+0.25*(((m1-m2).^2)./(v1+v2));
DB(isnan(DB))=0;
DB=DB+DB';
B=exp(-DB);
end