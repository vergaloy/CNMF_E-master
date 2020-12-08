function [N,G,R]=NSNA(mini,plotme,classif,av)
% [N,G,R]=NSNA(mini,1);

% [N,G,R]=NSNA(LCRA.early.fast.mini,1,1);
% [N,G,R]=NSNA(LCRA.late.fast.mini,1,1);
% [N,G,R]=NSNA(SCR.early.fast.mini,1,1);
% [N,G,R]=NSNA(SCR.late.fast.mini,1,1);
% [N,G,R]=NSNA(CN21.early.fast.mini,1,1);
% [N,G,R]=NSNA(CN21.late.fast.mini,1,1);



%  [N,G,R]=NSNA(LCRA.early.fast.clean,1,0);
%  [N,G,R]=NSNA(SCR.early.fast.clean,1,0,SCR.early.fast.av);
 if (classif==1)
[mini,av]=clasiffy_minis(mini);
 end
sm=nanmean(mini,1);
x=1:size(mini,2);
fitfun = fittype( @(tr,td,td2,A0,A1,A2,x) A0.*(1-exp(-x/tr)).*(A1*exp(-x/td)+A2*exp(-x/td2))   );
[fu,~] = fit(x',sm',fitfun,'StartPoint',[27,51,172,1,1,1],'Lower',[0,0,0,0,0,0]);  %,'Robust','LAR'
sm=feval(fu,x)';
m=sm*mean(av);
s=(mini.*av-av*sm).^2;
DF=-0.072;
[~,I]=max(sm);

m=m(I:end);
sm=sm(I:end);
s=s(:,I:end);
s1=nanmean(s,1);

bin=150;
x1=0;
for i=1:bin-1
    b=1-i/bin;
    x2=find(sm<=b,1);
    M(i)=mean(m(x1+1:x2));
    S(i)=mean(s1(:,x1+1:x2));
    x1=x2;
end
M(isnan(S))=[];
S(isnan(S))=[];
[~,mi]=max(S);

      S2=S(2/3*length(S):end);
      M2=M(2/3*length(S):end);

fitfun = fittype('poly2');
[Sr,gof] = fit(M2',S2',fitfun,'Robust','LAR');
R=gof.adjrsquare  ;
p=coeffvalues(Sr);

if (plotme==1)
      figure;
hold on

    x = linspace(0,max(roots(p)),1000);
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




