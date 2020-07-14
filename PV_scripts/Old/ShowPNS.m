

% show correlation image 
figure('position', [10, 500, 1776, 400]);
subplot(131);
imagesc(neuron.Cn, [0, 1]); colorbar;
axis equal off tight;
title('correlation image');

% show peak-to-noise ratio 
subplot(132);
imagesc(neuron.PNR,[0,max(neuron.PNR(:))]); colorbar;
axis equal off tight;
title('peak-to-noise ratio');

% show pointwise product of correlation image and peak-to-noise ratio 
subplot(133);
imagesc(neuron.Cn.*neuron.PNR, [0,max(neuron.PNR(:))]); colorbar;
axis equal off tight;
title('Cn*PNR');