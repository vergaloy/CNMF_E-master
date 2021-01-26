function output = cvtDrawCircle(X, cX, cY, cR, cL, varargin)
% This function is to draw circle 
% Input : X : image
%         cX: central X coordinate of the circle
%         cY: central Y coordinate of the circle
%         cR: radius
%         cL: color ([R, G, B])
%         varargin: optional, stepping for plotting the circle. default is 1
% output: the output
%
% This code is distributed under BSD License.
% Computer Vision Laboratory (CVLAB)
% Graduate school of Systems and Information Engineering
% University of Tsukuba
% 2016
%
% Email: tsukuba.cvlab@gmail.com
% HP: http://www.cvlab.cs.tsukuba.ac.jp/
%

if (numel(varargin) == 1)
    p = varargin{1};
else
    p = 1;
end

deg = 1:p:360;
coord = zeros(2,numel(deg));
coord(1,:) = ceil((cR+0.5) * sin (double(deg*pi/180.0))+cY);
coord(2,:) = ceil((cR+0.5) * cos (double(deg*pi/180.0))+cX);
[H,W,D] = size(X);
if (D == 1)
    output = cat(3,X,X,X);
else
    output = X;
end

for i=1:numel(deg)
    if (coord(1,i) > 0 && coord(1,i) < H && coord(2,i) > 0 && coord(2,i) < W)
        output(coord(1,i),coord(2,i),:) = cL;
    end
end

