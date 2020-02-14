function C = randcov(n,density,sd)

A = abs(sprandsym(n,density)); % generate a random n x n matrix

% since A(i,j) < 1 by construction and a symmetric diagonally dominant matrix
%   is symmetric positive definite, which can be ensured by adding nI
C = A + (sd).*speye(n);
C=C*C';
end