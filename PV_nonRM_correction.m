
clear;
gcp;
%% read data and convert to double
name = 'C:\Users\SSG Lab\Desktop\lab\vid.h5';
%addpath(genpath('../../NoRMCorre'));
Yf = read_file(name);
Yf = single(Yf);
[d1,d2,T] = size(Yf);

  
    hLarge = fspecial('average', 40);
    hSmall = fspecial('average', 2); 
    for t = 1:T
        Y(:,:,t) = filter2(hSmall,Yf(:,:,t)) - filter2(hLarge, Yf(:,:,t));
    end
    %Ypc = Yf - Y;
    bound = size(hLarge,1);



options_nr = NoRMCorreSetParms('d1',d1-bound,'d2',d2-bound,'bin_width',50, ...
    'grid_size',[70,70]*2,'mot_uf',4,'correct_bidir',false, ...
    'overlap_pre',32,'overlap_post',32,'max_shift',20);

tic; [Y,shifts2,template2] = normcorre_batch(Y(bound/2+1:end-bound/2,bound/2+1:end-bound/2,:),options_nr); toc % register filtered data
clear Y;
tic; Yf = apply_shifts(Yf,shifts2,options_nr,bound/2,bound/2); toc % apply the shifts to the removed percentile
Yf=Yf*10;
Yf=uint16(Yf);
saveash5(Yf, 'C:\Users\SSG Lab\Desktop\lab\mot_corrected.h5')
