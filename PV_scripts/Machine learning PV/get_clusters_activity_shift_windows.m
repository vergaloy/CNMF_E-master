function [Wg,Hg,Xg]=get_clusters_activity_shift_windows(mice_sleep,m,bin,active)
% [Ws,Hs,Xs]=get_clusters_activity_shift_windows(mice_sleep,3,2,active);
warning off
sf=5;
rng('default'); % for reproducibility
sep=10;
%%
Wg=cell(size(mice_sleep,1),1);
Hg=cell(size(mice_sleep,1),1);
Xg=cell(size(mice_sleep,1),1);
hi=0;

for i=1:size(mice_sleep,1)
    D=mice_sleep(i,:);
    D=catpad(2,D{:});
%     D=D(active(hi+1:size(D,1)+hi)==1,:);
    M=bin_data(D,sf,bin);
    lin=round(linspace(1,size(M,2),sep+1));
    W=[];
    cprintf('*blue','Finding ensemble activity in mice #%i.\n',i)
    upd = textprogressbar(sep,'updatestep',1,'endmsg','done.');
    for j=1:sep
        temp=M(:,lin(j):lin(j+1));
        w=get_pattern_in_batch(temp,m);
        W=catpad(2,W,w);
        upd(j);
    end
%     W(:,sum(W>0,1)<4)=[];
%     H=get_h_main(M,W);
    
     W=cluster_pattern(W,H);
      H=get_h_main(M,W);
    I=M;
     I(W*H==0)=0;
    o=double(sum(W,2)>0);
    [W,H]=get_cluster_activity_by_NMF2(I,o);
    
    [perm1,perm2]=sort_w(W,H,M);
    figure; SimpleWHPlot_PV(W(perm1,perm2),H(perm2,:),M(perm1,:));
    Wg{i}=W;
    Hg{i}=H;
    Xg{i}=M;
end

end


function W=cluster_pattern(W,H);
k=Cluster_data_PV2(H,'remove_0s',0,'Cmethod','ward','Cdist','cosine','plotme',0);
W=merge_patterns(W,H,k);
end

function O=merge_patterns(W,H,k)
for i=1:size(k,2)
    temp=W(:,k(:,i)>0);
    temp=temp*H(k(:,i)>0,:);
    O(:,i)=mean(temp,2);
end
end


function w=get_pattern_in_batch(in,m)
try
    k=Cluster_data_PV2(in,'remove_0s',1,'Cmethod','ward','Cdist',@cross_cosine_dist,'m',m,'plotme',0);
    [w,~]=get_cluster_activity_by_NMF2(in,k);
catch
    cprintf('*blue','K is empty at i=%i, and j=%i.\n',i)
    w=[];
end
end
