function [T,lags]=Get_burst(obj)
lag=600;
sf=5.02;
T(1:size(obj,1),1:lag+1)=0;
lags=(-lag/sf/2:1/sf:lag/sf/2);

for i=1:size(obj,1)
    T(i,:)=xcorr(obj(i,:),obj(i,:),lag/2,'unbiased'); 
    T(i,lag/2+1)=mean([T(i,lag/2),T(i,lag/2+2)]);
    %T=T./max(T,[],2);
end
subplot(4,1,[1 3]);
imagesc(lags,1:size(T,1),T)

S=sum(T,1);

temp=obj(:,randperm(size(obj,2)));
K(1:size(obj,1),1:lag+1)=0;
for i=1:size(temp,1)
    K(i,:)=xcorr(temp(i,:),temp(i,:),lag/2,'unbiased'); 
    K(i,lag/2+1)=mean([K(i,lag/2),K(i,lag/2+2)]);
   % K=K./max(K,[],2);
end

R=sum(K,1);

subplot(4,1,4);
plot(lags,[S;R]')





    