function data_erosion(mice_sleep,D,pix);

bin=2;

warning off
rng('default'); % for reproducibility
%%

[W1,H1,X1]=get_patt(mice_sleep,pix,[1,2,3],bin);
[Wall1,Hall1,Xall1]=get_cluster_activtiy_by_NMF_batch(X1,W1,H1,1);
[W2,H2,X2]=get_patt(mice_sleep,pix,[8,9],bin);
[Wall2,Hall2,Xall2]=get_cluster_activtiy_by_NMF_batch(X2,W2,H2,1);

Wc=catpad(2,Wall1{1, 1},Wall2{1, 1});
X=catpad(2,Xall1{1, 1},Xall2{1, 1});
Hc=blkdiag(Hall1{1, 1},Hall2{1, 1});
S=[size(D{1,1},2),size(D{1,2},2),size(D{1,3},2),size(D{1,8},2),size(D{1,9},2)];
Wc(Wc<1)=0;
f=Wc>0;
Wc(:,sum(f,1)<1)=[];
pix_e=get_pattern_cell_ix(X,Wc,S);




end


function [Ws,Hs,Xs]=get_patt(mice_sleep,pix,sessions,bin);
sf=5;

K=cell(size(mice_sleep,1),size(mice_sleep,2));
k=0;
for i=1:size(K,1)
    i
    D=mice_sleep(i,sessions);
    D=catpad(2,[],D{:});
    temp=bin_data(D,sf,bin);
    p_t=pix(k+1:k+size(temp,1));
    k=k+size(temp,1);
    out=erode(temp,p_t);
    
    try
        k=Cluster_data_PV(out,'remove_0s',1,...
            'Cmethod','complete','Cdist',@cross_cosine_dist,'m',1,'plotme',0);
        [w,h]=get_cluster_activity_by_NMF(temp,k,1);
        
        wt=squeeze(mean(w,3));
        [perm1,perm2]=sort_w(wt,h);
%         figure; SimpleWHPlot_PV(wt(perm1,perm2,:),h(perm2,:),temp(perm1,:));       
        Ws{i,1}=w;
        Hs{i,1}=h;
        Xs{i,1}=temp;
        
    catch
        cprintf('*blue','K is empty at i=%i, and j=%i.\n',i)
        Ws{i,1}=[];
        Hs{i,1}=[];
        Xs{i,1}=temp;
    end
end
end


function out=erode(temp,p_t)

y=sum(temp(p_t>0,:)==0,'all');

z=mean(temp(p_t==0,:)==0,'all')*numel(temp(p_t>0,:));
e=floor(z-y);
y=sum(temp(p_t>0,:)>0,'all');
p=e/y;
ze=rand(1,y)<p;

t=temp(p_t>0,:);
[n1,n2]=size(t);

t=t(:);
t(t>0)=t(t>0).*double(ze)';
t=reshape(t,[n1,n2]);

out=temp;
out(p_t>0,:)=t;






end








