function [W,H]=get_temporal_sequences(C);



clear textprogressbar
warning('off','all')
textprogressbar('Finding temporal sequences: ');
for i=1:size(C,2)
    textprogressbar((i/length(C))*100)
    for n=1:size(C{1,i},1)
        tn=C{1,i}(n,:);
        nf(n)=mean(tn(tn>0));
    end
    
    
    X=C{1,i}./nf';
    X(isnan(X))=0;
    
    X=[zeros(size(C{1,i},1),50),X];
    X(X>0)=1;
    
    K = 5;
    L = 1;
    lambda =.05;
    [W,H] = seqNMF(X,'K',K, 'L', L,'lambda', lambda,'tolerance',1e-4,'lambdaL1W',0.1,'showPlot',0);
    [pvals,is_significant] = test_significance(X,W,0.05,1000);
    
    W = W(:,is_significant,:);
    H = H(is_significant,:);
    
    H = circshift(H,round(L/2),2);
try
figure; SimpleWHPlot(W(:,:,:),H,X(:,:)); title('SeqNMF factors, with raw data')
catch
    dummy=1;
end
    
    Wout{i}=W;
    Hout{i}=H;
    
end
W=Wout;
H=Hout;
% H = circshift(H,round(L/2),2);
% H=H./max(H,[],2);
textprogressbar('Done: ');