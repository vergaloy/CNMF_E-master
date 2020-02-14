% Create rotation matrix
theta = 90; % to rotate 90 counterclockwise
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

t=t-mean(t,1);
% Rotate your point(s)
for i=1:size(t,1)
rot(i,:) = R*t(i,:)';
end

rot=rot.*5;

rot=rot+([5,5]);

scatter(t(:,1),t(:,2))
hold on
scatter(rot(:,1),rot(:,2))
rest=align_matrix(t,rot);
figure
scatter(t(:,1),t(:,2))
hold on
scatter(rest(:,1),rest(:,2),'.')
