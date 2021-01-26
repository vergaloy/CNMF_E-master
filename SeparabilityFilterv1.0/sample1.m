% Sample 1:
% This sample code is to demonstrate how to use the combined separability filter code
% for detecting pupils and nostrils in a very simple way.
%
% In practical situation, it is advisable to use multiple filter sizes and prepare a 
% dictionary data of pupils/nostrils/others for comparing the region on each local peak. 
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

% clear;
% 
% X = imread('testimages/sample1.png'); % sample1.png is a gray-scale CG generated face image
X= imread('C:\Users\BigBrain\Desktop\ruuuuth\TileScan 013_TileScan_001_Merging_Crop_ch00.tif');
X=double(X(2000:2500,1300:1700,3));
X=-X;
X=uint8(X-min(X,[],'all'));
[H, W] = size(X);
S1 = cat(3,X,X,X); % used for displaying final result (Geometric mean)
S2 = cat(3,X,X,X); % used for displaying final result (Arithmetic mean)
X = double(X); % convert data type to double
I1 = cvtIntegralImage(X);       % calculate integral image
P1 = cvtIntegralImage(X.^2);    % calculate integral image of squared pixel value
I2 = cvtIntegralImage45(X);     % calculate 45 degrees integral image
P2 = cvtIntegralImage45(X.^2);  % calculate 45 degrees integral image of squared pixel value

nR =3; % filter size parameter
nTH = 0.2; % threshold for finding local peaks

P = zeros(H,W,4);  % variable to store separability map
P(:,:,1:2) = cvtCombSimpRectFilter(I1,P1,nR);   % apply vertical and horizontal rectangular filters
P(:,:,3:4) = cvtCombSimpRectFilter45(I2,P2,nR); % apply diagonal left and right filters
P(P<0) = 0;
finalMap1 = prod(P(:,:,:),3).^(1/4.0);
finalMap2 = mean(P(:,:,:),3);

figure(10);clf;

for i=1:6
    subplot(2,4,i);
    if (i < 5)
        imagesc(P(:,:,i));
        axis equal tight;
        title(['separability map #' num2str(i)]);
    elseif (i==5)
        imagesc(finalMap1);
        axis equal tight;
        title('Geometric mean');
    elseif (i==6)
        imagesc(finalMap2);
        axis equal tight;
        title('Arithmetic mean');
    end
end

% find local peaks (Geometric mean)
PL1 = cvtFindLocalPeakX(finalMap1,1,nTH);
% draw circle and cross at each local peak with radius of the filter (nR)
for H=1:size(PL1,2)
    S1 = cvtDrawCircle(S1, PL1(2,H),PL1(1,H),nR,[255,0,0],20);
    S1 = cvtDrawCross(S1,PL1(2,H),PL1(1,H),nR,[255,255,255]);
end
subplot(2,4,7); 
image(S1); % display original
title({['Local peaks > ' num2str(nTH)]; 'Geometric mean'});
axis equal tight;

% find local peaks (Arithmetic mean)
PL2 = cvtFindLocalPeakX(finalMap2,1,nTH);
% draw circle and cross at each local peak with radius of the filter (nR)
for H=1:size(PL2,2)
    S2 = cvtDrawCircle(S2, PL2(2,H),PL2(1,H),nR,[255,0,0],20);
    S2 = cvtDrawCross(S2,PL2(2,H),PL2(1,H),nR,[255,255,255]);
end
subplot(2,4,8);
image(S2); % display original with marks for the local peak
axis equal tight;
title({['Local peaks > ' num2str(nTH)]; 'Arithmetic mean'});
