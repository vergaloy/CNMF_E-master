function fit_line(x,y)

type='Spearman';
scatter(x,y)
Fit = polyfit(x,y,1);
xFit = linspace(min(x), max(x), 50);
plot(xFit,polyval(Fit,xFit),'r','LineWidth',2);
% xlabel(xlab)
% ylabel(ylab)


[rho,p]=corrcoef(x',y')