function [A,burst_decay,P0]=estimate_parameters_from_neurons(mice_sleep,plotme)
% [A,burst_decay,P0]=estimate_parameters_from_neurons(mice_sleep,1);
X=mice_sleep(:,[1,2,3,5,6]);
X=[catpad(2,X{1,:});catpad(2,X{2,:});catpad(2,X{3,:});catpad(2,X{4,:})];

X=remove_zeros(X,size(X,2));
% X=bin_data(X,5,1);

%% Get random amplitudes
A=X(:);
A(A==0)=[];
[d,x] = histcounts(A,10000);
d=cumsum(d)/sum(d);
[~,i]=unique(d);
d=d(i);
x=x(i);

A=[x;d]';

n=size(X,2)-1;
parfor i=1:size(X,1)
   ct=X(i,:);
   temp=CXCORR(ct,ct);
C(i,:)=temp(2:n+1);
end


n=size(X,2)-1;
X2=datasample(X,size(X,2),2);
parfor i=1:size(X,1)
   ct=X2(i,:);
   temp=CXCORR(ct,ct);
C2(i,:)=temp(2:n+1);
end



burst_decay=get_burst_decay(C,C2,5,plotme);
P0=mean(C(:,50:end),2);

end

function [data,active]=remove_zeros(data,len)
active=data;
active(active~=0)=1;
active=1-mean(active,2);
active=active.^len;
active=active<0.05;
data=data(active,:);
end

function f1=get_burst_decay(C,C2,sf,plotme)


c=mean(C,1)';
c=c(1:120);
P0=mean(c(100:end));
c2=mean(C2,1)';
c2=c2(1:120);

n=length(c);
x=linspace(1/sf,n/sf,n)';
fitfun = fittype( @(a,b,y0,x) a*exp(-b*x)+y0);
f=fit(x,c,fitfun,'StartPoint',[80,0.1,P0],'Robust','LAR');
f1=f(x);
% c=c./f1(end);
% f1=f1./f1(end);
if (plotme==1)
figure;
plot(x(1:120),c(1:120),'b.');hold on
plot(x(1:120),c2(1:120),'g.');hold on
plot(x(1:120),f1(1:120),'r')
title('Transient probability')
xlabel('Lag (s)')
ylabel('dP/P0')
end
end
