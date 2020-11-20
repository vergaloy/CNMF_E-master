
[~,av1]=get_significant_weights(out{2,1});
[~,av2]=get_significant_weights(out{2,4});



[r,p]=corr(av);
figure;plotSpread(av1);yline(0);
values = {'HC-preS','HC-postS','HC-A','HC-C','preS-postS','preS-A','preS-C','postS-A','postS-C','A-C'}; 
heatmap_PV(av,values,[],1,'Colormap','money')
plot_heatmap_PV(r,p,values,'Partial-correaltion','money')

fit_line(av(:,1)-av(:,5),av(:,3),'HC-pre','HC-post')

i=10
h = kstest2(zscore(av1(:,i)),zscore(av2(:,i)))
h = kstest(zscore(av1(:,i)))
