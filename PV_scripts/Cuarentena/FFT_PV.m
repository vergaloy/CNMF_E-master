function [P1,f]=FFT_PV(S,Fs)

L=size(S,2);
Y = fft(S,[],2);
P2 = abs(Y).^2./L;
P1 = P2(:,1:floor(L/2)+1);
P1(:,2:end-1) = 2*P1(:,2:end-1);
f = (Fs*(0:ceil(L/2))/L)*1000;
 P1(1)=[];
f=f(1:length(P1));


