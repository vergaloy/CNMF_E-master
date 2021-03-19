function [ward,complete,average,centroid]=test_d3(mice_sleep)
% [ward,complete,average,centroid]=test_d3(mice_sleep);


[A,burst_decay,P0]=estimate_parameters_from_neurons(mice_sleep,1);
rep=1000;
upd = textprogressbar(rep,'updatestep',1);
u=0;
for r=1:rep
    [b,W]=simulate_Ca_data('A',A,'burst_decay',burst_decay,'P0',P0,'noise',2,'pat_n',[10,9,8,7,6,5,4,3,2],'pat_rep',50,'N',100,'L',58500);
    [Wc(r),Ww{r}]=get_stuff(b,W,'ward');
    [Cc(r),Cw{r}]=get_stuff(b,W,'complete');
    [Ac(r),Aw{r}]=get_stuff(b,W,'average');
    [Cc(r),Cw{r}]=get_stuff(b,W,'centroid');
    u=u+1;
    upd(u);
end
ward{1}=Wc;
ward{2}=Ww;
complete{1}=Cc;
complete{2}=Cw;
average{1}=Ac;
average{2}=Aw;
centroid{1}=Cc;
centroid{2}=Cw;
end



function [C,Wout]=get_stuff(b,W,method)
    [k,~,~]=Cluster_data_PV(b,'remove_0s',1,'Cmethod',method,'Cdist',@cross_cosine_dist,'m',3,'plotme',0);
%      perm = order_tree(z);  imagesc(b(perm,:)); 
    [w,h]=get_cluster_activity_by_NMF2(b,k);
%     h=conv2(1,gausswin(5),h,'same');
%     h(h>0)=1;
    % [perm1,perm2]=sort_w(w,h);
    % figure; SimpleWHPlot_PV(w(perm1,perm2),h(perm2,:),b(perm1,:));
    I=b;
    I((w*h)==0)=0;
    C=get_cosine(W(:),I(:));
    Wout=w;
end



