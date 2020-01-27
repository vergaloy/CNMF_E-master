function [Cn,PNR]=estimate_initialization_parameters_PV()
[file,path] = uigetfile('*.h5');
Y=h5read(strcat(path,file),'/Object');

cd(path)
parfor i=1:10 
[Cn(:,:,i), PNR(:,:,i)] = correlation_image_endoscope_PV(Y,(2+i),(2+i)*3);
end

figure
hold on
set(gcf, 'Position',  [200, 400, 1500, 400])
for i=1:10
subplot(2,5,i);
imagesc(PNR(:,:,i));
title(strcat('gSig=',num2str(i+2)))
caxis([2 10])
end
export_fig(strcat(file,'.pdf'), '-append');



figure
hold on
set(gcf, 'Position',  [200, 400, 1500, 400])
for i=1:10
subplot(2,5,i);
imagesc(Cn(:,:,i));
title(strcat('gSig=',num2str(i+2)))
end
export_fig(strcat(file,'.pdf'), '-append');

figure
hold
set(gcf, 'Position',  [200, 400, 1500, 400])
for i=1:10
subplot(2,5,i);
imagesc(PNR(:,:,i).*Cn(:,:,i));
title(strcat('gSig=',num2str(i+2)))
caxis([2 10])
end

export_fig(strcat(file,'.pdf'), '-append');