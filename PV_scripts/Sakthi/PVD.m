
function [distance,F]=PVD(X1,X2,sim)

%rng('default') % For reproducibility




X1=multivariate_bootstrap(X1',sim);
X2=multivariate_bootstrap(X2',sim);
%distance=double(MRPP(X1',X2',sim));

Xp1(1:sim)=0;
Xp2(1:sim)=0;
for i=1:sim
Xp1(i)=mahalanobis_point(X1,X2(i,:));
end
for i=1:sim
Xp2(i)=mahalanobis_point(X2,X1(i,:));
end

distance=mean([Xp1,Xp2]);









