function out=SVM_ABNs_matrix(D)


b=nchoosek(1:size(D,2),2);

%% Create matrices to store accuracies between behavioral states.

T=zeros(size(D,2));   %test data
P=zeros(size(D,2));   %permutation control, destroy differences between behaviourla states, keep correlations. 
C=zeros(size(D,2));   %Completly random 
R=zeros(size(D,2));   %Shuffle points inside a condition, destroy correlation and mean differneces between neurons.  
S=zeros(size(D,2));   %Shift rows, destroy correlation but preserve mean differneces between neurons. 

%% Create array to store weight vectors between behavioral states.

wT=zeros(size(D,2),size(D,2),size(D{1, 1},1));
wP=zeros(size(D,2),size(D,2),size(D{1, 1},1));
wC=zeros(size(D,2),size(D,2),size(D{1, 1},1));
wR=zeros(size(D,2),size(D,2),size(D{1, 1},1));
wS=zeros(size(D,2),size(D,2),size(D{1, 1},1));

for i=1:size(b,1)
    c1=b(i,1);
    c2=b(i,2);
    [tT,tP,tS,tR,tC]=prepare_train_Data(D,1,[c1,c2]);
    [~, T(c1,c2),wT(c1,c2,:)] = trainClassifierPV(tT,0);
    [~, P(c1,c2),wP(c1,c2,:)] = trainClassifierPV(tP,0);
    [~, C(c1,c2),wC(c1,c2,:)] = trainClassifierPV(tC,0);
    [~, R(c1,c2),wR(c1,c2,:)] = trainClassifierPV(tR,0);
    [~, S(c1,c2),wS(c1,c2,:)] = trainClassifierPV(tS,0);
end

out={T,P,S,R,C;wT,wP,wS,wR,wC};


    