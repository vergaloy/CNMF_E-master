function sim_event(P0,burst_decay)
% sim_event(0.005,burst_decay)
sim=10000;
sf=5;

m=1;
k=120;

P=double(rand(1,sim*sf)<P0);
t=(conv(P,burst_decay-1)*P0);
t=t(1:sim*sf);
P=double(rand(1,sim*sf)<t);

for i=1:sim*sf
    P(i)=double(rand()<(P0));
    if P(i)>0
        k=0;
    end
    
    if k<120
        k=k+1;
    end
        m=burst_decay(k);
end

temp=CXCORR(P,P);
temp=temp(2:200);
P2=datasample(P,size(P,2));
temp2=CXCORR(P2,P2);
temp2=temp2(2:end/2);


f1=get_burst_decay(temp,sf,1)
f2=get_burst_decay(temp2,sf,1)
end

function f1=get_burst_decay(C,sf,plotme)

c=C';
po=mean(c(150:end));
n=length(c);
x=linspace(1/sf,n/sf,n)';
fitfun = fittype( @(a,b,y0,x) a*exp(-b*x)+y0);
f=fit(x,c,fitfun,'StartPoint',[80,0.1,po],'Robust','LAR');
f1=f(x);
% c=c/f1(end);
% f1=f1/f1(end);
if (plotme==1)
figure;
plot(x(1:n),c(1:n),'b.');hold on
plot(x(1:n),f1(1:n),'r')
title('Transient probability')
xlabel('Lag (s)')
ylabel('dP/P0')
end
end
        
    
    
    