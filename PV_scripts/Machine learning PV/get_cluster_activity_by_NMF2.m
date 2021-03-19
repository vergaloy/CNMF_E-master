function [W,H]=ExtractEnssambles(X,K)

    a=sum(K,2)>0;  %% get ensemble forming neurons (candidates)
    X2=X(sum(K,2)>0,:);  %% Remove neurons that are not forming patterns.
    k=NumberOfAssemblies(X2);
    
    [w,~] = seqNMF(X2,'K',k, 'L', 1,'lambda', 0,'maxiter',100,'showplot',0,'lambdaOrthoW',1);  %% run seqNMF

    %% Remove small component from w
    indempty = sum(sum(w>0,1),3)==0; % W is literally empty
    ep=get_percentage_of_explained_power(w);
    indempty = indempty | ep<0.05;   % Remove components from W whose cumulative power is less than 5%
    indempty = indempty | (max(w).^2> .999*sum(w.^2,1)); % or one neuron has >99.9% of the power
    w(indempty)=0;
    %%
    
    H=get_h_main(X2,w);  %get H by random permutations
    W=zeros(size(a,1),size(w,2));
    W(a,:)=w;
%     [perm1,perm2]=sort_w(W,H,X);
%     figure; SimpleWHPlot_PV(W(perm1,perm2),H(perm2,:),X(perm1,:));

    
end


function ep=get_percentage_of_explained_power(w)
p=(w.^2)./sum(w.^2,1);
for i=1:size(p,1)
    ep(i,:)=1-sum(p.*((p-p(i,:))>0),1);
end

end

function N = NumberOfAssemblies(S)
S = S';
S(:,sum(S,1)==0)=[];
CorrMatrix = corr(S);
CorrMatrix(isnan(CorrMatrix))=0;
[~,d] = eig(CorrMatrix);
d=real(d);
eigenvalues=diag(d);
%Marchenko–Pastur
lambda_max = prctile(circular_shift(S',500),95);
N = sum(eigenvalues>lambda_max);
end




function H=get_h_main(X,W)
X(X>0)=1; % here the weights in W do not matter
for i=1:size(W,2)
    w=W(:,i,:);
    wt=squeeze(mean(w,3));
    x=X(wt>0,:);
    w(wt==0,:,:)=[];
    x(:,isnan(sum(x,1)))=0;   
    h=get_h(x,w);
    H(i,:)=h;
end
end

function h=get_h(in,w)
len=size(w,3);
k=size(w,2);
[~,h] = seqNMF(in,'K',k, 'L', len,'lambda', 0,'maxiter',1,'showplot',0,'W_init',w);
s=[];
parfor i=1:1000
    temp = circshift_columns(in')';
    [~,h_t]=seqNMF(temp,'K',k, 'L', len,'lambda', 0,'maxiter',1,'showplot',0,'W_init',w);
    %     temp=xCosine(temp,w,m);
    %     temp(temp==0)=[];
    h_t(h_t==0)=[];
    s=[s;h_t'];
end
h(h<prctile(s,95))=0;
end


