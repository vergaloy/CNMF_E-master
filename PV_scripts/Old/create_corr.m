function out=create_corr(ob,bin,sf)
out=binndata(ob,bin,sf);
out = corrcoef(out);
out(isnan(out))=0;
