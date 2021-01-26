
gSig=4;
psf = fspecial('gaussian', ceil(gSig*4+1), gSig);
        ind_nonzero = (psf(:)>=max(psf(:,1)));
        psf = psf-mean(psf(ind_nonzero));
        psf(~ind_nonzero) = 0;

        
        
        HY = imfilter(nuc, psf, 'replicate');
        
        imagesc(nuc(900:1050,900:1050));figure;imagesc(HY(900:1050,900:1050))
 
        [d1,d2]=size(nuc);
        
        HY = reshape(HY, d1*d2, []);
% HY_med = median(HY, 2);
% HY_max = max(HY, [], 2)-HY_med;    % maximum projection
HY = bsxfun(@minus, HY, median(HY, 1));
HY_max = max(HY, [], 2);
Ysig = GetSn(HY);
PNR = reshape(HY_max./Ysig, d1, d2);

HY_thr = HY;
HY_thr(bsxfun(@lt, HY_thr, Ysig*gSig*3)) = 0;
