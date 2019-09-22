function A=makebits(n)
%MAKEBITS Produce bit array of N bits with all combinations of 1s and 0s.
%
% Example: makebits(3)' produces
%
%   0 0 0 0 1 1 1 1
%   0 0 1 1 0 0 1 1
%   0 1 0 1 0 1 0 1
%
% but of course you can flip it to the transverse.
%
% I used this for testing communications channels.
% Make rows, each something like 0 1 2 3 ...
r = [ 0:2^n-1 ];
A = [];
for i = 1 : n
 A = [A;r];
end
% Make columns, each something like c = [8 4 2 1]';
c = [];
for i = 0 : n-1
 c = [ 2^i c ];
end
c = c';
B = [];
for i = 1 : 2^n
 B = [B c];
end
A=sign(bitand(A,B))';
% Done.
