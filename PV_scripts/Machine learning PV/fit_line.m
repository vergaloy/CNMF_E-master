function fit_line(x,y,xlab,ylab,type)


figure;scatter(x,y)
Fit = polyfit(x,y,1);
xFit = linspace(min(x), max(x), 50);
hold on; plot(xFit,polyval(Fit,xFit),'r','LineWidth',2);
xlabel(xlab)
ylabel(ylab)


[rho,p]=corr(x,y,'Type',type)