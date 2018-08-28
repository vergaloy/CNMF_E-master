
% Specify the folder where the files live.
myFolder = 'F:\Calcium_Imaging_Tokyo\All extracted data\analyze';
savefiles=1;
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end

filePattern = fullfile(myFolder, '*.h*'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
for k=1:length(theFiles)
  tic
  clearvars -except filePattern theFiles k myFolder
  close all
  baseFileName = theFiles(k).name;
  filename = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', filename);

%%
%%==============


vid=h5read(filename,strcat('/images'));

vid=permute(vid,[2 1 3]);

%%
%%=====================================
%%
vid=im2int16(vid);
%%
%======================================
fprintf('Preprocessing data...');
[~,vid]=preprocess_data(vid,2);
%%=====================================

[d1,d2,T] = size(vid);
fprintf('Correcting motion...');

    hLarge = fspecial('average', 40);
    hSmall = fspecial('average', 2); 
    vid2(1:d1,1:d2,size(vid,3))=int16(0);
    parfor t = 1:size(vid,3)
        vid2(:,:,t) = filter2(hSmall,vid(:,:,t)) - filter2(hLarge, vid(:,:,t));
    end
    bound = size(hLarge,1);
    
    options_nr = NoRMCorreSetParms('d1',d1-bound,'d2',d2-bound,'bin_width',50, ...
    'grid_size',[128,128]*2,'mot_uf',4,'correct_bidir',false, ...
    'overlap_pre',32,'overlap_post',32,'max_shift',20);

    tic; [~,shifts2,template2] = normcorre_batch(vid2(bound/2+1:end-bound/2,bound/2+1:end-bound/2,:),options_nr); toc % register filtered data
    tic; vid = apply_shifts(vid,shifts2,options_nr,bound/2,bound/2); toc % apply the shifts to the removed percentile
clear vid2

fprintf('Calculating average fluorescence decay...');
bleaching(1:size(vid,3))=0;
parfor i=1:size(vid,3)
    bleaching(i)=mean(mean(vid(:,:,i)))   
end
vid=im2uint16(vid);

saveash5(vid, strcat('C:\Users\SSG Lab\Desktop\motion corrected\batch8\',baseFileName))

end