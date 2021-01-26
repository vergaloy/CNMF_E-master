function plot_spearman_partial_corr(x,y,z)
% plot_spearman_partial_corr(x,y,z)

xr=tiedrank(x);
yr=tiedrank(y);
zr=tiedrank(z);

c = polyfit(zr,xr,1);
xre=xr-polyval(c,zr);

c = polyfit(zr,yr,1);
yre=yr-polyval(c,zr);


corr(xre,yre)

fit_line(xre,yre);
[rho,pval] = partialcorr(x,y,z,'Type','Spearman')
[rho,pval] = partialcorr(x,y,z)