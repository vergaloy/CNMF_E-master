% Sample 3:
% This sample code is to demonstrate how to use the combined separability filter code
% to detect micro features on facial surface by using multi-scale filters.
%
% If you use this code, we would appreciate if you cite the following paper(s):
% 
% [1] Y. Ohkawa, C. H. Suryanto, K. Fukui, 
% "Fast Combined Separability Filter for Detecting Circular Objects", 
% The twelfth IAPR conference on Machine Vision Applications (MVA) pp.99-103, 2011.
%
% [2] K. Fukui, O. Yamaguchi, 
% "Facial feature point extraction method based on combination of shape extraction 
%  and pattern matching", Systems and Computers in Japan 29 (6), pp.49-58, 1998.
%
% This code is distributed under BSD License.
% Computer Vision Laboratory (CVLAB)
% Graduate school of Systems and Information Engineering
% University of Tsukuba
% 2016
%
% Email: tsukuba.cvlab@gmail.com
% HP: http://www.cvlab.cs.tsukuba.ac.jp/
%

clear;
% 
% %Read Image
% Im = imread('testimages/cheek.jpg');
% gr = double(rgb2gray(Im));
% figure(30);clf;
% image(Im);
% axis equal tight;
% title('Original parts of face');TileScan 013_TileScan_001_Merging_Crop_ch00.tif
% X= imread('C:\Users\BigBrain\Desktop\ruuuuth\TileScan 013_TileScan_001_Merging_Crop_ch00.tif');
 X= imread('C:\Users\BigBrain\Desktop\ruuuuth\TileScan 013_TileScan_001_Merging_Crop_ch01.tif');
 X=double(X(2000:2500,1300:1700,2));
 Or=uint8(X*256);
% X=double(X(:,:,2));
X=-X;
gr=X-min(X,[],'all');
Im=gr;




%Create Integral Image
tic
I1 = cvtIntegralImage(gr);
P1 = cvtIntegralImage(gr.^2);
I2 = cvtIntegralImage45(gr);
P2 = cvtIntegralImage45(gr.^2);

%Create Separability Map
geoMap   = zeros(size(gr,1),size(gr,2));
arithMap = zeros(size(gr,1),size(gr,2));
for nR = 5:1:15, %multiple scales of separability filter's size (radius)
    P(:,:,1:2) = cvtCombSimpRectFilter(I1,P1,nR);
    P(:,:,3:4) = cvtCombSimpRectFilter45(I2,P2,nR);
    P(P<=0)=0;
    geoMap_tmp= (prod(P,3)).^(1/4);
    arithMap_tmp = sum(P,3)/4;
    geoMap = max(geoMap, geoMap_tmp);
    arithMap = max(arithMap, arithMap_tmp);
end
timerequired=toc;
fprintf('Time required: %g seconds\n',timerequired);

figure(31);clf;
subplot(2,2,1);
imagesc(geoMap);
axis equal tight;
title('Separability map (geometric mean)');

subplot(2,2,2);
imagesc(arithMap);
axis equal tight;
title('Separability map (arithmetic mean)');

subplot(2,2,3);
image(imfuse(gr,geoMap));
axis equal tight;
title('Fused image (geometric mean)');

subplot(2,2,4);
image(imfuse(gr,arithMap));
axis equal tight;
title('Fused image (arithmetic mean)');


nTH = 0.7; % threshold for local peaks

% Find and draw local peak's marks for geoMap (geometric mean)
S1 = imfuse(gr,geoMap);
PL1 = cvtFindLocalPeakX(geoMap,1,nTH);
imshow( Or);
for H=1:size(PL1,2)
    % draw cross at each local peak (cross size is relative to the peak value)
%     S1 = cvtDrawCircle(S1, PL1(2,H),PL1(1,H),round(8*PL1(3,H)),[255,255,255]);
 plot_elipese(PL1(2,H),PL1(1,H),round(8*PL1(3,H)))
end
figure(32);clf;
image(S1);
title(['Fused image with local peaks (Geometric mean) > ' num2str(nTH)], 'fontweight','bold');
axis equal tight;

% Find and draw local peak's marks for arithMap (arithmetic mean)
S2 = imfuse(gr,arithMap);
 J = imcomplement(rgb2gray(S2));

PL2 = cvtFindLocalPeakX(arithMap,1,nTH);
imagesc(Or);
for H=1:size(PL2,2)
    % draw cross at each local peak (cross size is relative to the peak value)
    plot_elipese(PL2(2,H),PL2(1,H),round(8*PL2(3,H)))
%     S2 = cvtDrawCircle(P, PL2(2,H),PL2(1,H),round(8*PL2(3,H)),[128,0,128]);
end
figure(33);clf;
image(S2);
axis equal tight;
title(['Fused image with local peaks (Arithmetic mean) > ' num2str(nTH)], 'fontweight','bold');
