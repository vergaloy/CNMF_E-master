function [out,m]=clasiffy_minis(mini)
% out=clasiffy_minis(LCRA_ef);
mini=mini';
x=1:size(mini,2);
m=prctile(mini,99,2);
fitfun = fittype( @(tr,td,td2,A0,A1,A2,x) A0.*(1-exp(-x/tr)).*(A1*exp(-x/td)+A2*exp(-x/td2))   );
r_thr=0.95

out=mini;

parfor i=1:size(mini,1)
    temp=mini(i,:);
    temp=temp-mean(temp(700:1000));
    temp=temp./max(temp);
    try
        [fu,gof] = fit(x',temp',fitfun,'StartPoint',[27,51,172,1,1,1],'Lower',[0,0,0,0,0,0]);  %,'Robust','LAR'
        co= coeffvalues(fu);
        f=feval(fu,x);
        [s(i),I]=max(f);
        temp=temp./s(i);
        f=f./s(i);
        
        Tr(i)=co(1)/20;
        Td(i)=((co(5)*co(2)+co(6)*co(3))/(co(5)+co(6)))/20;
      
%                  temp=temp(I:size(temp,2));
%                  f=f(I:length(f));
        r_t=gof.adjrsquare;
        sse(i)=gof.sse;
        if r_t>r_thr
%              plot(f);hold on;plot(temp);hold off
           out(i,:)=temp;
        end
        
        if (isempty(r_t))
            r_t=0;
        end
        r(i)=r_t;
    catch
        r(i)=0;
        Tr(i)=0;
        Td(i)=0;
    end  
end
out(r<r_thr,:)=[];
Tr(r<r_thr)=[];
Td(r<r_thr)=[];
m(r<r_thr)=[];
mt=m;
X=[Td;mt']';
Xt=zscore(X);
[mu,S,RD,chi_crt]=DetectMultVarOutliers(Xt,[],[],false);
id_out=RD>chi_crt(4);

X=(X-mean(X(~id_out,:),1))./std(X(~id_out,:),[],1);


scatter(X(~id_out,1),X(~id_out,2),'*');hold on;scatter(X(id_out,1),X(id_out,2),'*');

m(id_out)=[];
out(id_out,:)=[];







