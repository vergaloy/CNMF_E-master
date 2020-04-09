function [W,H,indSort]=Get_seqNMF(C,exclud,po,plotme)
% [W,H,indsort]=Get_seqNMF(D,[1,2],0.99,1);


L = 1;
lambda =0.3;  %0.3 dev

X=[];
t=0;
for i=1:size(C,2)
    if (~ismember(i,exclud))
        X=[X,full(C{1,i})];
        t=t+1;
        siz(t)=size(C{1,i},2);
    end
end


X(X>0)=1;
k=get_patterns(X);


numfits = 200; %number of fits to compare
inds = nchoosek(1:numfits,2);

Converged=0;

while (Converged==0)
    parfor ii = 1:numfits
        [Wt,Ht] = seqNMF(X,'K',k, 'L', L,'lambda', lambda,'maxiter',100,'showplot',0,'lambdaOrthoW',1,'tolerance', 1e-4);
        
        indempty = sum(sum(Wt>0,1),3)==0; % W is literally empty
        Wflat = sum(Wt,3);
        indempty = indempty | (max(Wflat,[],1).^2> po*sum(Wflat.^2,1)); % or one neuron has >99.9% of the power
        Wt(:,indempty,:)=[];
        Ht(indempty,:)=[];
        Ws{ii}=Wt;
        Hs{ii}=Ht;
    end
    
    [W0,H0] = get_most_likely_pattern(cell2mat(Ws),cell2mat(Hs'),k,numfits);
    k_new=size(W0,2);
    
    if (k_new<k)
        k=k-1;
    else
        Converged=1;
    end
    
end   
    [W,H] = seqNMF(X,'K',k_new, 'L', L,'lambda', 0,'maxiter',100,'showplot',0,'lambdaOrthoW',1,'tolerance', 1e-4,'W_init',W0,'H_init',H0);
    indempty = sum(sum(W>0,1),3)==0; % W is literally empty
    Wflat = sum(W,3);
    indempty = indempty | (max(Wflat,[],1).^2> po*sum(Wflat.^2,1)); % or one neuron has >99.9% of the power
    W(:,indempty,:)=[];
    H(indempty,:)=[];
    

try
    [max_factor, L_sort, max_sort, hybrid] = helper.ClusterByFactor(W(:,sum(W,1)>0,:),1);
catch
    dummy=1
end
indSort = hybrid(:,3);

if(k==1)
    [~,indSort]=sort(W,1,'descend');
end



if (plotme)
    figure; SimpleWHPlot(W(indSort,:,:),H,X(indSort,:)); title('SeqNMF factors, with raw data')
    axdrag
    t=0;
    for i=1:size(siz,2)
        t=t+siz(i);
        le(i)=t;
        xline(t);
    end
    
    %     get_pattern_activity(Y,H,le);
end









