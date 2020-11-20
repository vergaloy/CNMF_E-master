function motion_correct_PV()

pattern='*.h5';
myFolder=uigetdir;
filePattern = fullfile(myFolder, pattern);
theFiles = dir(filePattern);

for i=1:size(theFiles,1)
    baseFileName = theFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);


Yf = read_file(fullFileName);
Yf = single(Yf);
[d1,d2,T] = size(Yf);



    gSig = 4; 
    gSiz = 3*gSig; 
    psf = fspecial('gaussian', round(2*gSiz), gSig);
    ind_nonzero = (psf(:)>=max(psf(:,1)));
    psf = psf-mean(psf(ind_nonzero));
    psf(~ind_nonzero) = 0;   % only use pixels within the center disk
    %Y = imfilter(Yf,psf,'same');
    %bound = 2*ceil(gSiz/2);
    Y = imfilter(Yf,psf,'symmetric');
    bound = 0;
    
end