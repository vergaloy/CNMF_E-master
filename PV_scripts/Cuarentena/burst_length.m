function [m,p]=burst_length(A,Fs)
% [y3]=burst_length(D{1,9},0.5);
%% Gaussian smoothing of signal
w = gausswin(50);
% A = filter(w,1,A')';
len=size(A,2);
B(1:size(A,1))=0;
m(1:size(A,1))=0;

parfor i=1:size(A,1)
    x1=A(i,:);
    [t1,f]=Welch_PV(x1,Fs,30);
    
    temp=xcorr(x1,'normalized');
    w1(i,:)=temp(round(length(temp)/2)+1:end);

    w95=create_95ci(x1,Fs);
    t2=prctile(w95,95,1);
    
    temp=xcorr(datasample(x1,size(x1,2),'Replace',false),'normalized');
    w2(i,:)=temp(round(length(temp)/2)+1:end);
    
    
    i1=find(f>20,1);
    i2=find(f>75,1);
    
    mp=max(t1(i1:i2))-max(t2(i1:i2));
    
   m(i)=mp;
   p(i)=sum(t1(i1:i2));
end
n=p;
n(isnan(n))=-100;
[~,I]=sort(n,'descend');
imagesc(A(I,:));
end


function W=create_95ci(x,Fs)
for s=1:100
len=size(x,2);
W(s,:)=Welch_PV(datasample(x,len,'Replace',false),Fs,30);
end
W=W./sum(W,2);
end