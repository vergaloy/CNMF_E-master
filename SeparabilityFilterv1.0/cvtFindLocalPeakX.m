function PeakList = cvtFindLocalPeakX(X, Flg, Thres)
% Function to find local peak
% Input: X: data with size H and W
%        Flg: set 1 to find highest peaks, set to -1 to find lowest peaks
%        Thres: threshold of the peaks' value
% Output: PeakList: list of sorted peak coordinates and values
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

if nargin < 2
   error('error');
end


if nargin == 2
   B = ones(size(X));
end

if nargin == 3
   if Flg == 1
      B = (X > (Thres));
   elseif Flg == -1
      B = (X < (Thres));
   else
      error('error');
   end
end

if nargin == 4
   if Flg == 1
      B = (X > (Thres));
   elseif Flg == -1
      B = (X < (Thres));
   else
      error('error');
   end
end

if nargin > 3
   error('error');
end

N = 1; % number of neighborhood peak

B(1,:) = 0;
B(end,:) = 0;
B(:,1) = 0;
B(:,end) = 0;

[a,b] = find(B);
Candinate = [a,b]';
PeakList = zeros([3,size(Candinate,2)]);
cnt=0;

if Flg == 1
   for l= 1:size(Candinate,2);
      y = Candinate(1,l);
      x =  Candinate(2,l);
      tmp = X(y-1:y+1,x-1:x+1); %  consider 8 neighbor pixel
      tmp = tmp(:);
      [val, ind ] = sort(tmp,'descend');

      for n=1:N
         if (ind(n) == 5)
            cnt = cnt+1;
            PeakList(:,cnt) = [Candinate(:,l);val(n)];
         end
      end
   end
   PeakList = PeakList(:,1:cnt);
   [ksk, ind] = sort(PeakList(3,:),'descend');
   PeakList = PeakList(:,ind);

elseif Flg == -1
   for l= 1:size(Candinate,2);
      y = Candinate(1,l);
      x =  Candinate(2,l);
      tmp = X(y-1:y+1,x-1:x+1); %  consider 8 neighbor pixel
      tmp = tmp(:);
      [val, ind ] = sort(tmp,'ascend');
      for n=1:N
         if (ind(n) == 5)
            cnt = cnt+1;
            PeakList(:,cnt) = [Candinate(:,l);val(n)];
         end
      end
   end
   PeakList = PeakList(:,1:cnt);
   [ksk, ind] = sort(PeakList(3,:),'ascend');
   PeakList = PeakList(:,ind);
end

