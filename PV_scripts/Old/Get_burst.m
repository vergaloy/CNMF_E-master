function [T,lags,burst_rate]=Get_burst(obj,sf,vplot)
lag=1200;
T(1:size(obj,1),1:lag+1)=0;
lags=(-lag/sf/2:1/sf:lag/sf/2);

for i=1:size(obj,1)
    T(i,:)=xcorr(obj(i,:),obj(i,:),lag/2,'unbiased'); 
    T(i,lag/2+1)=mean([T(i,lag/2),T(i,lag/2+2)]);
    %T=T./max(T,[],2);
end

if (vplot==1)
subplot(4,1,[1 3]);
imagesc(lags,1:size(T,1),T)
colormap('jet')
caxis([0 0.1])
end
S=sum(T,1);

temp=obj(:,randperm(size(obj,2)));
K(1:size(obj,1),1:lag+1)=0;
for i=1:size(temp,1)
    K(i,:)=xcorr(temp(i,:),temp(i,:),lag/2,'unbiased'); 
    K(i,lag/2+1)=mean([K(i,lag/2),K(i,lag/2+2)]);
   % K=K./max(K,[],2);
end
R=sum(K,1);

if (vplot==1)
subplot(4,1,4);
plot(lags,[S;R]')
end

bt=8;  %burst duration in s
burst_rate(size(obj,1),1:bt)=0;
for i=1:10
M=bin_data(obj,round(sf),bt,1/round(sf),0);
M=M-i+1;
M(M>0)=1;
M(M<0)=0;
burst_rate(:,i)=mean(M,2)./(bt*round(sf));
end



    