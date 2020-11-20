function [m,p]=burst_length(A,Fs)
% [y3]=burst_length(D{1,2},0.5);

len=size(A,2);
B(1:size(A,1))=0;
m(1:size(A,1))=0;

for i=1:size(A,1)
    x1=A(i,:);
    [t1,f]=Welch_PV(x1,Fs,30);
    T(i,:)=t1; %spectogram of each neuron
    temp=xcorr(x1,'normalized');
    w1(i,:)=temp(round(length(temp)/2)+1:end);  %correlation of each neuron

    w95=create_95ci(x1,Fs);
    t2=prctile(w95,95,1);
    
    temp=xcorr(datasample(x1,size(x1,2),'Replace',false),'normalized');
    %w2(i,:)=temp(round(length(temp)/2)+1:end); %correlation of each neuron randomized
    Tr(i,:)=mean(w95,1); %spectogram of each neuron
    
    i1=find(f>20,1);
    i2=find(f>75,1);
    
    mp=max(t1(i1:i2))-max(t2(i1:i2));
    
   m(i)=mp;
   p(i)=sum(t1(i1:i2))./sum(t1);
end
[~,f]=Welch_PV(A(1,:),Fs,30);
n=p;
n(isnan(n))=-100;
[~,I]=sort(n,'descend');
figure
imagesc(A(I,:));

t1=nanmean(T,1);
t1=t1./sum(t1);
t2=nanmean(Tr,1);
t2=t2./sum(t2);

figure
hold on;
a=area(f,t1);
a.FaceAlpha = 0.5;
b=area(f,t2);
b.FaceAlpha = 0.5;
xlabel('mHz');
ylabel('Power density');
end


function W=create_95ci(x,Fs)
for s=1:100
len=size(x,2);
W(s,:)=Welch_PV(datasample(x,len,'Replace',false),Fs,30);
end
W=W./sum(W,2);
end