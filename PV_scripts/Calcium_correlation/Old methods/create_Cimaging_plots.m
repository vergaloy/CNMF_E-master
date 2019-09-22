%%
figure;
set(gcf, 'Position',  [0, 0, 2000, 800]);
S=sleepdata.wake;
S=S./max(S,[],2);
S=[S;sleepdata.bin.twake];
stackedplot(S');
clearvars S;
export_fig Results.pdf -append;
%%
figure;
set(gcf, 'Position',  [500, 400, 1000, 400]);
h1=subplot(1,2,1);
imagesc(sleepdata.bin.wake);
ylabel(h1,'neuron #');
xlabel(h1,'Burst epoch');
title("Wake");
caxis([0 1]);
colormap('hot');
hold on;
h2=subplot(1,2,2);
imagesc(sleepdata.bin.nrem);
ylabel(h2,'neuron #');
xlabel(h2,'Burst epoch');
title("NREM");
caxis([0 1]);
colormap('hot');
export_fig Results.pdf -append;
%%
figure;
scatter(sleepdata.coor.DvR(:,1),sleepdata.coor.DvR(:,2));
ylabel('Activity correlation');
xlabel('Neuron distance');
ylim([-0.5 1]);
export_fig Results.pdf -append;
%%
figure;
set(gcf, 'Position',  [500, 400, 1000, 400]);
subplot(1,2,1);
imagesc(sleepdata.cor.wake);
ylabel('Compared burst epoch');
xlabel('Reference burst epoch');
title("Wake "+sleepdata.cor.wake_sumcorr_P);
mycolormap;
subplot(1,2,2);
imagesc(sleepdata.cor.nrem);
ylabel('Compared burst epoch');
xlabel('Reference burst epoch');
title("NREM "+sleepdata.cor.nrem_sumcorr_P)
mycolormap;
export_fig Results.pdf -append;
%%
figure;
set(gcf, 'Position',  [0, 100, 2000, 700]);
h1=subplot(2,12,1:12);
imagesc(sleepdata.bin.all);
ylabel(h1,'neuron #');
xlabel(h1,'Burst epoch');
caxis([0 1]);
colorbar;
h2=subplot(2,12,13);
imagesc(sleepdata.nmf.all.W);
ylabel(h2,'neuron #');
xlabel(h2,'Pattern');
subplot(2,12,15:24);
h3=stackedplot(sleepdata.nmf.all.H');
h3.DisplayLabels= strsplit(num2str(1:size(sleepdata.nmf.all.H,1)));
title('Patterns Activity');
colormap('hot');
export_fig Results.pdf -append;
clearvars h1 h2 h3;

neuron.Coor=[];
neuron.show_contours(0.6, [], neuron.PNR, false);
export_fig Results.pdf -append;
