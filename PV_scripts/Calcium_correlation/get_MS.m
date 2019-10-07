function [MS]=get_MS(V1,V2)

if(size(V1,2)>size(V2,2))
new = zeros(size(V1));
new(1:size(V2,1),1:size(V2,2)) = V2;
V2=new;
end

if(size(V1,2)<size(V2,2))
new = zeros(size(V2));
new(1:size(V1,1),1:size(V1,2)) = V1;
V1=new;
end


p=perms(1:size(V1,2));
MSs(1:size(p,1))=0;
for i=1:size(p,1)
        Vt2=V2(:,p(i,:));
        MSs(i)=nanmean(dot(V1,Vt2)./(sqrt(sum((V1).^2,1)).*sqrt(sum((Vt2).^2,1))));
end
MS=max(MSs,[],2);
end
