function patern_activity_ratio(pa,a,data,active,sf,bin,pix)
a=a(:,[1,2,3,8,9]);
par=pa./a;
par(isnan(par))=0;

[~,~,n]=get_concantenated_data(data,sf,bin);
n=n(active);

for i=1:max(n)
    ta=a(n==i,:);
    tpa=pa(n==i,:);
out(i,:)=mean(tpa,1)./mean(ta,1);
end
out


n1=n(pix==1,:);
par1=par(pix==1,:);




for i=1:max(n1)
    tpa=par1(n1==i,:);
out1(i,:)=mean(tpa,1);
end
out1

n2=n(pix==2,:);
par2=par(pix==2,:);


for i=1:max(n2)
    tpa=par2(n2==i,:);
out2(i,:)=nanmean(tpa,1);
end
out2






