function P=statistical_power_Ttest(x1,x2)

% fast=statistical_power_Ttest(0,1.491);

s=2.1082;
for n=1:30 
    
    n1=n*4;
    t=(x1-x2)/(s/sqrt(n1-2));
    P(n)=tcdf(t,n1-2)*4;
end
P=P';