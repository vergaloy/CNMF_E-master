function [N,G,R]=NSNA(mini,plotme)
% [N,G,R]=NSNA(late_fast,1);

m=mean(mini,1);
sm=m/max(m);
s=mini./max(mini,[],2).*max(m);
DF=-0.072;
[~,I]=max(sm);

m=m(I:end);
sm=sm(I:end);
s=s(:,I:end);

bin=30;
x1=0;
for i=1:bin-1
    b=1-i/bin;
    x2=find(sm<=b,1);
    M(i)=mean(m(x1+1:x2));
    S(i)=var(mean(s(:,x1+1:x2),2));
    x1=x2;
end
[~,ml]=max(S);

S=[0,S(ml-3:end)];
M=[0,M(ml-3:end)];
p = polyfit(M,S,2);
Sr = polyval(p,M);
R=corrcoef(S,Sr);
R=R(1,2);

if (plotme==1)
      figure;
hold on
    x = linspace(0,max(M)+1,1000);
    y = polyval(p,x);
    plot(x,y);hold on;scatter(M,S)
    xlabel('Amplitude (pA)')
    ylabel('Variance (pA^2)')
end

N=-1/p(1);
G=-p(2)/DF;

N=N';
G=G';
R=R';



