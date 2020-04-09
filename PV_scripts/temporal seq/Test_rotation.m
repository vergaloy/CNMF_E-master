
A=[1,5,5,1,1;1,1,5,5,1]';
plot(A(:,1),A(:,2),'r-');
theta = 30; % to rotate 90 counterclockwise
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% Rotate your point(s)

rA = (A*R-5)*2+(rand(5,2)-0.5)*1;
hold on
plot(rA(:,1),rA(:,2),'b-');

xlim([-15 15])
ylim([-15 15])

fA=align_matrix(A,rA);

plot(fA(:,1),fA(:,2),'g-');

figure
plot(fA(:,1),fA(:,2),'r-');
fA=align_matrix(A,fA);
hold on
plot(fA(:,1),fA(:,2),'b-');