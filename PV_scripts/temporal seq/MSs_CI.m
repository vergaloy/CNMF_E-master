function [M,lc,uc]=MSs_CI(MSs)

d=size(MSs,1);
lc(1:d,1:d)=0;
uc(1:d,1:d)=0;
M(1:d,1:d)=0;
for i=1:d
    for j=1:d
        t=squeeze(MSs(i,j,:));
        lc(i,j)=prctile(t,5);
        uc(i,j)=prctile(t,95);
        M(i,j)=mean(t);
    end
end