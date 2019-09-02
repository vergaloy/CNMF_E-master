ob=sleepdata;  %name of the folder storing the calcium transients
bin=1;  % bin size of the correlated calcium activity in seconds
sf=5.02; %sample frequncy
end_range=100;  % number of trials to show


ob.b.CWB=create_corr(ob.b.CW,bin,sf) ;
ob.b.CNB=create_corr(ob.b.CN,bin,sf) ;
ob.a.CWB=create_corr(ob.a.CW,bin,sf) ;
ob.a.CNB=create_corr(ob.a.CN,bin,sf) ;


figure
subplot 221;
imagesc(ob.b.CWB);
set(gca,'YDir','normal')
mycolormap()
caxis([-.6 .801])

subplot 222;
imagesc(ob.a.CWB)
set(gca,'YDir','normal')
mycolormap()
caxis([-.6 .801])

subplot 223;
imagesc(ob.b.CNB)
set(gca,'YDir','normal')
mycolormap()
caxis([-.6 .801])

subplot 224;
imagesc(ob.a.CNB)
set(gca,'YDir','normal')
mycolormap()
caxis([-.6 .801])

figure
subplot 221;
imagesc(ob.b.CW);
caxis([0 .2])
xticks(1:sf*600:end_range*sf*60)
xt = get(gca, 'XTick');                                 % 'XTick' Values
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sf/60))

subplot 222;
imagesc(ob.a.CW);
caxis([0 .2])
xticks(1:sf*600:end_range*sf*60)
xt = get(gca, 'XTick');                                 % 'XTick' Values
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sf/60))

subplot 223;
imagesc(ob.b.CN);
caxis([0 .2])
xticks(1:sf*600:end_range*sf*60)
xt = get(gca, 'XTick');                                 % 'XTick' Values
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sf/60))

subplot 224;
imagesc(ob.a.CN);
caxis([0 .2])
xticks(1:sf*600:end_range*sf*60)
xt = get(gca, 'XTick');                                 % 'XTick' Values
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sf/60))

%M1=ob;
clear ob bin sf






