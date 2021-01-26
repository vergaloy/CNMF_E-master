function C=test_d2(mice_sleep)
% C2b=test_d2(mice_sleep);

no=2.^(-5:1:4);
pat_n=(2:11);
pat_rep=ceil(0.5*exp(0.6.*(1:10)));
[A,burst_decay,P0]=estimate_parameters_from_neurons(mice_sleep,1);
rep=100;
C=zeros(rep,1);
tic
upd = textprogressbar(100,'updatestep',1);
u=0;
for r=1:rep
    [b,W]=simulate_Ca_data('A',A,'burst_decay',burst_decay,'P0',P0,'noise',2,'pat_n',5,'pat_rep',5);
    [k,~,z]=Cluster_data_PV(b,'remove_0s',1,'Cmethod','ward','Cdist',@cross_cosine_dist,'m',1,'plotme',1);
%      perm = order_tree(z);  imagesc(b(perm,:)); 
    [w,h]=get_cluster_activity_by_NMF(b,k,1);
    h=conv2(1,gausswin(5),h,'same');
    h(h>0)=1;
    % [perm1,perm2]=sort_w(w,h);
    % figure; SimpleWHPlot_PV(w(perm1,perm2),h(perm2,:),b(perm1,:));
    I=b;
    I((w*h)==0)=0;
    C(r)=get_cosine(W(:),I(:));
    if (get_cosine(W(:),I(:))==0)
       dummy=1; 
    end
    u=u+1;
    upd(u);
end
toc
end






