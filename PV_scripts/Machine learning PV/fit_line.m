function fit_line(x,y)


figure;scatter(x,y)
Fit = polyfit(x,y,1);
xFit = linspace(min(x), max(x), 50);
hold on; plot(xFit,polyval(Fit,xFit),'r','LineWidth',2);

[rho,p]=corr(x,y,'Type','Spearman')