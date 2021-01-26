function MAP = cvtCombSimpRectFilter(I,P,sh)
% Function to generate separability map for rectangular filters (vertical and horizontal)
% Input: I: integral image, obtained by using cvtIntegralImage45(X);
%        P: integral image of the square pixel values, obtained by using cvtIntegralImage45(X.^2);
%        sh: size of the filter
% Output: MAP: two separability maps (diagonal left and diagonal right), with size: [Height, Width, 2].
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
% This code is written by Yasuhiro Ohkawa and distributed under BSD License.
% Computer Vision Laboratory (CVLAB)
% Graduate school of Systems and Information Engineering
% University of Tsukuba
% 2016
%
% Email: tsukuba.cvlab@gmail.com
% HP: http://www.cvlab.cs.tsukuba.ac.jp/
%

bh = sh*2;
bw = ceil(sh/3);
sw = ceil(sh/3);
dh  =0;
dw  =0;

MAP(:,:,1) = tmpFnc(I,P,bh,bw,sh,sw,dh,dw);
MAP(:,:,2) = tmpFnc(I,P,bw,bh,sw,sh,dh,dw);

end

%%
function MAP = tmpFnc(I,P,bh,bw,sh,sw,dh,dw)
MAP   = zeros(size(I)-1);
[H,W] = size(MAP);
r = max([bh,bw]);
N  = (2*bh+1)*(2*bw+1);
N1 = (2*sh+1)*(2*sw+1);
N2 = N-N1;

S =I((1+r:H-r)-bh,(1+r:W-r)-bw) + I((1+r:H-r)+bh+1,(1+r:W-r)+bw+1) - I((1+r:H-r)-bh,(1+r:W-r)+bw+1) -I((1+r:H-r)+bh+1,(1+r:W-r)-bw);
T =P((1+r:H-r)-bh,(1+r:W-r)-bw) + P((1+r:H-r)+bh+1,(1+r:W-r)+bw+1) - P((1+r:H-r)-bh,(1+r:W-r)+bw+1) -P((1+r:H-r)+bh+1,(1+r:W-r)-bw);

M = S./N;
Y = T./N;
St = Y - M.^2;
S1 =I((1+r:H-r)-sh+dh,(1+r:W-r)-sw+dw) + I((1+r:H-r)+sh+dh+1,(1+r:W-r)+sw+dw+1) - I((1+r:H-r)-sh+dh,(1+r:W-r)+sw+dw+1) - I((1+r:H-r)+sh+dh+1,(1+r:W-r)-sw+dw);
S2=S-S1;
M1=S1./N1;
M2=S2./N2;

Sb = ((N1*((M1-M).^2)) + (N2*((M2-M).^2)))/N;
MAP((1+r:H-r),(1+r:W-r)) = (Sb./St).*sign(M2-M1);
MAP(isnan(MAP))=0;
MAP(isinf(MAP))=0;
end
