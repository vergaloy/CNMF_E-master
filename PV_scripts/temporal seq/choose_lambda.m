function choose_lambda(C)

X=[];

% for i=1:size(C,2)
%     X=[X,full(C{1,i})];
% end
X=full(C{1,3});
warning('off','all')
warning



%% Procedure for choosing lambda
nLambdas = 50; % increase if you're patient
K = 6;
%X = trainNEURAL;
lambdas = sort([logspace(-3,0,nLambdas)], 'ascend');
regularization = [];
cost = [];
loop=length(lambdas)
[N,T] = size(X);
rep=10;
updateWaitbar = waitbarParfor(rep*loop, "Calculation in progress...");
for r=1:rep
    parfor li = 1:loop
        [W,H]= seqNMF(X,'K',K,'L',1,...
            'lambdaL1W', 0, 'lambda', lambdas(li), 'maxiter', 30, 'showPlot', 0,'lambdaOrthoH',1);
        [cost(r,li),regularization(r,li),~] = helper.get_seqNMF_cost(X,W,H); 
        updateWaitbar();
    end    
end
%% plot costs as a function of lambda
cost=mean(cost,1);
regularization=mean(regularization,1);

windowSize = 5; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
Rs = filtfilt(b,a,regularization); 
minRs = prctile(regularization,1); maxRs= prctile(regularization,99);
Rs = (Rs-minRs)/(maxRs-minRs); 
R = (regularization-minRs)/(maxRs-minRs); 
Cs = filtfilt(b,a,cost); 
minCs =  prctile(cost,1); maxCs =  prctile(cost,99); 
Cs = (Cs -minCs)/(maxCs-minCs); 
C = (cost -minCs)/(maxCs-minCs); 

clf; hold on
plot(lambdas,Rs, 'b')
plot(lambdas,Cs,'r')
scatter(lambdas, R, 'b', 'markerfacecolor', 'flat');
scatter(lambdas, C, 'r', 'markerfacecolor', 'flat');
xlabel('Lambda'); ylabel('Cost (au)')
set(legend('Correlation cost', 'Reconstruction cost'), 'Box', 'on')
set(gca, 'xscale', 'log', 'ytick', [], 'color', 'none')
set(gca,'color','none','tickdir','out','ticklength', [0.025, 0.025])