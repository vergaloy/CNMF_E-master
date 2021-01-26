function segmentate_ruth();

X= imread('C:\Users\BigBrain\Desktop\ruuuuth\TileScan 013_TileScan_001_Merging_Crop_ch01.tif');
 X=double(X(:,:,2));
grayIm=mat2gray(X);
dSize=3;


gMap= imopen(grayIm, strel('disk', dSize));
I_eq = adapthisteq(gMap,'Distribution','exponential');
bw = im2bw(I_eq,graythresh(I_eq));
bw = imopen(bw, ones(5,5));
bw = bwareaopen(bw, 80);
bw = ~bwareaopen(~bw, 10);
imshow(imfuse(grayIm,bwperim(bw)));
D = -bwdist(~bw);

ma=I_eq>0.99;
imshow(imfuse(grayIm,bwperim(ma)));
D2 = -bwdist(~ma);
mask = imextendedmin(D2,3);

D3 = imimposemin(D,mask);

Ld2 = watershed(D3);
bw2 = bw;
bw2(Ld2 == 0) = 0;
bw2 = imopen(bw2, ones(5,5));
bw2 = bwareaopen(bw2, 80);
bw2 = ~bwareaopen(~bw2, 10);

imshow(imfuse(grayIm,bwperim(bw2)));