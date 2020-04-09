function K_cross_validation(X)


%% K sweep with masked cross-validation
nReps = 20; % increase if patient
Ks = 1:15; % increase if patient
L = 2;
% X = NEURAL; 
[N,T] = size(X);
RmseTrain = zeros(length(Ks), nReps);
RmseTest = zeros(length(Ks), nReps);
figure
[~,Kplot] = meshgrid(1:nReps, Ks); 
Kplot = Kplot + rand(length(Ks), nReps)*.25-.125; 
parfor K = Ks
    for repi = 1:nReps
        display(['Cross validation on masked test set; Testing K = ' num2str(K) ', rep ' num2str(repi)])
        rng('shuffle')
        M = rand(N,T)>.2; % create masking matrix (0's are test set, not used for fit)
        [W,H] = seqNMF(X,'K', K, 'L', L,'lambda', 0,'showPlot', 0,'lambdaOrthoW',0, 'M', M); 
        Xhat = helper.reconstruct(W,H); 
        RmseTrain(K,repi) = sqrt(sum(M(:).*(X(:)-Xhat(:)).^2)./sum(M(:)));
        RmseTest(K,repi) = sqrt(sum((~M(:)).*(X(:)-Xhat(:)).^2)./sum(~M(:)));
    end
end

clf; scatter(Kplot(:), RmseTrain(:), 'r', 'markerfacecolor', 'flat'); 
hold on; 
scatter(Kplot(:), RmseTest(:), 'b', 'markerfacecolor', 'flat'); 
plot(median(RmseTrain,2), 'r')
plot(median(RmseTest,2), 'b')
xlabel('K'); ylabel('RMSE')
h_legend=legend('Train', 'Test');
drawnow; shg