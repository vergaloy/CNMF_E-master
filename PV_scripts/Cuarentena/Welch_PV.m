function [C,f]=Welch_PV(x,Fs,w_percent)

w=round(length(x)*w_percent/100);
T=length(x);
n= 2*round(T/w)-1;
ranges = round(linspace(1, T, n+1));
C={};
if (length(ranges)==2)
  r=1;
  p=1;
else
r=length(ranges)-2;
p=2;
end
for i=1:r
    temp=x(ranges(i):ranges(i+p));
%     temp=CXCORR(temp,temp);
    temp=xcorr(temp,'normalized');
    temp=temp(round(length(temp)/2)+1:end);
    [C{i,1},f]=FFT_PV(temp,Fs);
end
C=padcat(C{:});
C(isnan(C))=0;
C=mean(C,1);