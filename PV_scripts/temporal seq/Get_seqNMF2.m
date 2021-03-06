function [W,H,indSort]=Get_seqNMF2(C,exclud,po,plotme)
% [W,H,indsort]=Get_seqNMF2(C,[1,3,4,5,6,7,8,9],0.99,1);


L = 1;
lambda =0.6;  %0.3 dev

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
if (k==0)
    k=1;
end


numfits = 100; %number of fits to compare




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
    
                
    
     W0=NMF(cell2mat(Ws),k);
     
     k_new=size(W0,2);
 
    [W,H] = seqNMF(X,'K',k_new, 'L', L,'lambda', lambda,'maxiter',100,'showplot',0,'lambdaOrthoW',1,'tolerance', 1e-4,'W_init',W0);
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









