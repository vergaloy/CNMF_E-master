% I = imread('https://blogs.mathworks.com/images/steve/60/nuclei.png');
% I= imread('C:\Users\BigBrain\Desktop\ruuuuth\TileScan 013_TileScan_001_Merging_Crop_ch00.tif');
% I= imread('C:\Users\BigBrain\Desktop\ruuuuth\TileScan 013_TileScan_001_Merging_Crop_ch01.tif');
% 
% I=I(:,:,2);
% % % I=I(:,:,2);
%  Hs = fspecial('disk',5);
%  Hb = fspecial('disk',30);
% %   I_eq = imgaussfilt(I,7); 
%   a = adapthisteq(I,'distribution','exponential');
% b =adapthisteq(imfilter(I,Hb,'replicate'),'distribution','exponential'); 
% %  -imfilter(I,Hb,'replicate');
I_eq=geoMap;
I=Or;
% imshow(I)
X=J;

%  I_eq2 = adapthisteq(I_eq);
% figure;imshow(I_eq)

bw = imbinarize(X);
bw2 = imfill(bw,'holes'); 
se = strel('disk',3);
bw3 = imopen(bw2, se);
bw4 = bwareaopen(bw3, 45); 
bw4_perim = bwperim(bw4);

overlay1 = imoverlay(X, bw4_perim, [.3 1 .3]);
figure;imshow(overlay1)
X2=double(X);
X2(bw4==0)=255;

X2=-X2+255;
X2=X2./max(X2,[],'all');

bw = imbinarize(X2);

X=X2;
% I_eq2 = adapthisteq(T);
% mask_em = imextendedmax(I_eq2, 0.8);
% imshow(mask_em)

% mask_em = imclose(mask_em, ones(3,3));
% mask_em = imfill(mask_em, 'holes');
% mask_em = bwareaopen(mask_em, 25);
% overlay2 = imoverlay(I, bw4_perim | mask_em, [.3 1 .3]);
% % imshow(overlay2)

% I_eq_c = imcomplement(I_eq2);
% I_mod = imimposemin(I_eq_c, ~bw4 | mask_em);

D = bwdist(~bw4);
D=-D;
% figure;imshow(D,[])
L = watershed(D);
L(~bw4) = 0;
% figure;imshow(L)
stats = cell2mat(struct2cell(regionprops(L,'Area')));
 L(ismember(L,find(stats>5000)))=0;
 
% figure;imshow(label2rgb(L))
B = labeloverlay(I,L);
figure;imshow(B)





