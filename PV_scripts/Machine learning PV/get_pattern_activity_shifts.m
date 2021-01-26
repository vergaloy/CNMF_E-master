function [W,H]=get_pattern_activity_shifts(M,sep)
lin=round(linspace(1,size(M,2),sep+1));
    W=[];
    for j=1:sep
        temp=M(:,lin(j):lin(j+1));
        w=get_pattern_in_batch(temp,m);
        W=catpad(2,W,w);
    end
    W(:,sum(W>0,1)<4)=[];
    H=get_h_main(M,W);
%     I=M;
%     I(W*H==0)=0;
%     o=double(sum(W,2)>0);
%     [W,H]=get_cluster_activity_by_NMF2(I,o);
    
    [perm1,perm2]=sort_w(W,H,M);
    figure; SimpleWHPlot_PV(W(perm1,perm2),H(perm2,:),M(perm1,:));
end

function w=get_pattern_in_batch(in,m)
try
    k=Cluster_data_PV(in,'remove_0s',1,'Cmethod','ward','Cdist',@cross_cosine_dist,'m',m,'plotme',0);
    [w,~]=get_cluster_activity_by_NMF2(in,k);
catch
    cprintf('*blue','K is empty at i=%i, and j=%i.\n',i)
    w=[];
end
end
