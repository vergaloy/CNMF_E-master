% Sample 4:
% This sample code is to demonstrate the results and computational time 
% using the original circular separability filter proposed in [2]
% to detect micro features on facial surface (The same as in sample3.m).
%  -> Note that the computational time is much slower than that of sample3.m 
%     while the results are very similar.
%
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
% title('Original parts of face');

X= imread('C:\Users\BigBrain\Desktop\ruuuuth\TileScan 013_TileScan_001_Merging_Crop_ch01.tif');
X=double(X(2000:2500,1300:1700,2));
X=-X;
gr=X-min(X,[],'all');
Im=gr;

tic
circMap = zeros(size(gr,1),size(gr,2));
for nR = 8:2:12, %multiple scales of separability filter's size (radius)
    r=nR; % radius (please refer to [2])
    r1=nR; % inner circle radius (please refer to [2])
    r2=nR; % outer circle radius (please refer to [2])
    cMap = cvtCircleSepFilter(gr, r, r1, r2);
    circMap = max(circMap, cMap);
end
timerequired=toc;
fprintf('Time required: %g seconds\n',timerequired);

figure(41);clf;
subplot(1,2,1);
imagesc(cMap);
axis equal tight;
title('Separability map (circular filter)');

subplot(1,2,2);
image(imfuse(gr,cMap));
axis equal tight;
title('Fused image (circular filter)');

% find local peaks
nTH = 0.1; % threshold for local peaks 
S1 = imfuse(gr,cMap);
PL = cvtFindLocalPeakX(cMap,1,nTH);
for H=1:size(PL,2)
    % draw cross at each local peak (cross size is relative to the peak value)
    S1 = cvtDrawCross(S1, PL(2,H),PL(1,H),round(10*PL(3,H)),[255,255,255]);
end
figure(42);clf;
image(S1);
axis equal tight;
title(['Local peaks > ' num2str(nTH) ' (original circular filter)'],'fontweight','bold');
