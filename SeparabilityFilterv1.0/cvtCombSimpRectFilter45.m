function MAP = cvtCombSimpRectFilter45(I,P,sh)
% Function to generate separability map for diagonal filters (diagonal left and right)
% Input: I: 45 degrees integral image, obtained by using cvtIntegralImage45(X);
%        P: 45 degrees integral image of the square pixel values, obtained by using cvtIntegralImage45(X.^2);
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


r = round(sh/sqrt(2));
w = ceil(sh/3/sqrt(2));
br = 2*r;

MAP(:,:,1) = tmpFnc(I,P,r,br,w,w);
MAP(:,:,2) = tmpFnc(I,P,w,w,r,br);

end

%%
function MAP = tmpFnc(I,P,r,br,w,bw)

MAP = zeros(size(I)-1);
[H, W] = size(MAP);

h = bw+br+2;
N =(2*bw+1)*(2*(1+2*br));
N1=(2*w+1)*(2*(1+2*r));
N2=N-N1;

HH = bw + br +1+1:H-(bw + br +2);
WW = bw + br +3:W-(bw + br+1);
P1 = I(HH - bw - br -1      ,WW + bw - br - 1);
P2 = I(HH + bw - br -1+1    ,WW - bw - br - 1-1  );
P3 = I(HH + bw + br +1      ,WW - bw + br - 1);
P4 = I(HH - bw + br         ,WW + bw + br    );
S = (P4+P2-P3-P1);

P1 = P(HH - bw - br -1      ,WW + bw - br - 1);
P2 = P(HH + bw - br -1+1    ,WW - bw - br - 1-1  );
P3 = P(HH + bw + br +1      ,WW - bw + br - 1);
P4 = P(HH - bw + br         ,WW + bw + br    );
T= (P4+P2-P3-P1);

M = S./N;
Y = T./N;
St = Y - M.^2;

P1 = I(HH - w - r -1      ,WW + w - r - 1);
P2 = I(HH + w - r -1+1    ,WW - w - r - 1-1  );
P3 = I(HH + w + r +1      ,WW - w + r - 1);
P4 = I(HH - w + r         ,WW + w + r    );
S1= (P4+P2-P3-P1);

S2=S-S1;
M1=S1/N1;
M2=S2/N2;

Sb = ((N1*((M1-M).^2)) + (N2*((M2-M).^2)))/N;

MAP(h:end-h,h:end-h)=(Sb./St).*sign(M2-M1);
MAP(isnan(MAP))=0;
MAP(isinf(MAP))=0;
end

