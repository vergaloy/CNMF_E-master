% Using pegasos algorithm to solve a simple linear SVM classifier without 
% a bias term (b)
% Note that we use CVX libarary to first optimal value, and then report the
% convergence rate for pegasos algorithm

clear;
clc;

% load data
load q1x.dat
load q1y.dat

% define variables
X = q1x;
Y = 2*(q1y-0.5);



%%
[train_num, feature_num] = size(X);
lambda = 0.001; % it can be set as 1/C
maxIter = 1000;
[w, fval] = pegasos(X,Y,lambda,[],maxIter,10);

% reporting accuracy
t_num = sum(sign(X * w) == Y);
accuracy = 100 * t_num / train_num;
fprintf('Accuracy on training set is %.4f %%\n', accuracy);



% visualize
figure(2), clf
xp = linspace(min(X(:,1)), max(X(:,1)), 100);
yp = - w(1) * xp / w(2);
yp1 = - (w(1)*xp - 1) / w(2); % margin boundary for support vectors for y=1
yp0 = - (w(1)*xp + 1) / w(2); % margin boundary for support vectors for y=0

% index of negative samples
idx0 = find(Y==1);
% index of positive samples
idx1 = find(Y==-1);

plot(X(idx0, 1), X(idx0, 2), 'rx'); 
hold on
plot(X(idx1, 1), X(idx1, 2), 'go');
plot(xp, yp, '-b', xp, yp1, '--g', xp, yp0, '--r');
hold off
title(sprintf('decision boundary for a linear SVM classifier with lambda = %g', lambda));
