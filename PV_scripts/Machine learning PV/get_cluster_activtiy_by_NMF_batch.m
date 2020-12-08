function [Wall,Hall,Xall]=get_cluster_activtiy_by_NMF_batch(X,W,H,plotme)

[Wall,Hall,Xall]=group_W_H(X,W,H);

if (plotme)
    for i=1:size(Xall,2)
        w=Wall{i};
        h=Hall{i};
        x=Xall{i};
        wt=squeeze(mean(w,3));
        [perm1,perm2]=sort_w(wt,h);
        figure; SimpleWHPlot_PV(wt(perm1,perm2),h(perm2,:),x(perm1,:));       
    end
end
end



function [Wall,Hall,Xall]=group_W_H(X,W,H)

Wall=cell(1,size(W,2));
Hall=cell(1,size(H,2));
Xall=cell(1,size(H,2));
for i=1:size(W,2)
    Tw=[];
    Th=[];
    Tx=[];
    a=0;
    for j=1:size(W,1)
        w=W{j,i};
        h=H{j,i};
        x=X{j,i};
        if (isempty(w))
            w=zeros(size(X{j,i},1),1);
            h=zeros(1,size(X{j,i},2));
        end
        w=catpad(2,zeros(length(w),a),w);
        Tw=catpad(1,Tw,w);
        Tx=catpad(1,Tx,x);
        a=size(Tw,2);
        Th=catpad(1,Th,h);
    end
    Tw(isnan(Tw))=0;
    Th(isnan(Th))=0;
    a=squeeze(mean(Tw,3));
    a=sum(a,1)>0;
    Wall{i}=Tw(:,a,:);
    Hall{i}=Th(a,:);
    Xall{i}=Tx;
end

end

