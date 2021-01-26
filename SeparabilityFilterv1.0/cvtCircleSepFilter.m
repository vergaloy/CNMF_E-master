function MAP = cvtCircleSepFilter(img, r, wi, wo)
% Function to generate separability map using a circular mask filter
% Input: img: gray-scale image 
%        r: radius of center circle 
%        wi: inner radius (described as r1 in the reference paper [1])
%        wo: outer radius (described as r2 in the reference paper [1])
% Output: MAP: separability map
%
% If you use this code, we would appreciate if you cite the following paper:
%
% [1] K. Fukui, O. Yamaguchi, 
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

[H, W] = size(img);
X = double(img);
MAP = zeros(size(X));

L = 2 * (r + wo) +1;
c = r+wo+1;
N1 = 0;
N2 = 0;
List1=zeros(L^2,2);
List2=zeros(L^2,2);
MASK = zeros(L,L);
for py=1:L;
   for px = 1:L;
      if (r^2) >= ((c-py)^2 + (c-px)^2) && (r-wi)^2 <= ((c-py)^2 + (c-px)^2)
         MASK(py,px) = 0.5;
         N1 = N1 + 1;
         List1(N1,:) =[py,px];
      elseif (r+wo)^2 >= ((c-py)^2 + (c-px)^2) && (r^2) <= ((c-py)^2 + (c-px)^2)
         MASK(py,px) = 1;
         N2 = N2 + 1;
         List2(N2,:) =[py,px];
      end
   end
end

List1 = List1(1:N1,:);
List2 = List2(1:N2,:);

N = N1 + N2;

V1 = zeros(N1,1);
V2 = zeros(N2,1);
for y=1:H-L+1;
   for x=1:W-L+1;
      for l = 1:size(List1,1)
         V1(l) = X(List1(l,1)+y-1,List1(l,2)+x-1);
      end
      for l = 1:size(List2,1)
         V2(l) = X(List2(l,1)+y-1,List2(l,2)+x-1);
      end

      M = mean([V1;V2]);
      St = cov([V1;V2],1);
      if St == 0
         MAP(y+c-1,x+c-1) = 0;
      else
         M1 = mean(V1);
         M2 = mean(V2);
         Sb = ((N1*((M1-M)^2)) + (N2*((M2-M)^2)))/N;
         MAP(y+c-1,x+c-1) = Sb/St;
      end
   end
end
