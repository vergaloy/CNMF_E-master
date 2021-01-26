function output = cvtDrawCross(X, cX, cY, cR, cL)
% This function is to draw a vertical and horizontal line (cross shape + )
% Input : X : image
%         cX: central X coordinate of the cross
%         cY: central Y coordinate of the cross
%         cR: length of cross from the central
%         cL: color ([R, G, B])
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

[H,W,D] = size(X);
if (D == 1)
    output = cat(3,X,X,X);
else
    output = X;
end

B=-cR:cR;

Yline = B+cY;
Yline(Yline<1 | Yline>H)=[]; % ensure the cross is within X

Xline = B+cX;
Xline(Xline<1 | Xline>W)=[]; % ensure the cross is within X

output(Yline, cX,:)=repmat(cL,numel(Yline),1);
output(cY,    Xline,:)=repmat(cL,numel(Xline),1);