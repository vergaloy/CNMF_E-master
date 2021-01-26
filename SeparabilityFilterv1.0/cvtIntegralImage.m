function Z = cvtIntegralImage(X)
% Function to generate an integral image
% Input: X: gray scale image
% Output: X: integral image
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

Z = zeros(size(X)+1);
Z(2:size(Z,1),2:size(Z,2)) =  cumsum(cumsum(X,1),2);
