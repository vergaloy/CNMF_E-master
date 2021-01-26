function f1=get_burst_rate(X);
% get_burst_rate(X);

% m=mice_sleep(:,[1,2,3,8,9]);
% X=[catpad(2,m{1,:});catpad(2,m{2,:});catpad(2,m{3,:})];
X=double(X);
X(X>0)=1;

c=get_xcor(X,100);


x=linspace(0.2,20,100)';

fitfun = fittype( @(a,b,y0,x) a*exp(-b*x)+y0);
f=fit(x,c,fitfun,'StartPoint',[0.0575,0.3955,0.0029],'Robust','LAR');
coef=coeffvalues(f);
P0=coef(2);
P1=(1-coef(2)/5);
% figure;tiledlayout('flow');nexttile;
% plot(f,x,c)
% title('Burst xcov')
% xlabel('Lag (s)')
% ylabel('Correlation')

f1=f(x);
f1=f1/min(f1);

% nexttile
% plot(x,f1)
% title('Transient probability')
% xlabel('s')
% ylabel('Probability')
end

function c=get_xcor(X,n)
c=zeros(size(X,1),n);
parfor i=1:size(X,1)
   a=X(i,:);
   temp=CXCORR(a,a);
c(i,:)=temp(2:n+1);
end
c=nanmean(c,1)';
end

function out=shuffle_row(in)
out=zeros(size(in,1),size(in,2));
for i=1:size(in,1)
    out(i,:)=in(i,randperm(size(in,2),size(in,2)));   
end
end

    
    
    
    

