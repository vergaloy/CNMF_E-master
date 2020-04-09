function out=align_matrix(X,Y)

n=size(X,2);
d=mean(X,1);
X=X-d;
Y=Y-mean(Y,1);
[A,phi,C] = svd(X'*Y);


T=C*A';  %optimal rotation
s=trace(X'*Y*T)/trace(Y'*Y);  %optimal dilatation
M=s*Y*T;

% t=(n^-1)*(X-M)'; %optimal translation
t=d;
out=M+t;


% TEST EXAMPLE
% A=[1,5,5,1,1;1,1,5,5,1]';
% plot(A(:,1),A(:,2),'r-');
% theta = 30; % to rotate 90 counterclockwise
% R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% % Rotate your point(s)
% 
% rA = (A*R-5)*2+(rand(5,2)-0.5)*1;
% hold on
% plot(rA(:,1),rA(:,2),'b-');
% 
% xlim([-15 15])
% ylim([-15 15])
% 
% fA=align_matrix(A,rA);
% 
% plot(fA(:,1),fA(:,2),'g-');