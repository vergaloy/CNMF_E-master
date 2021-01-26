function [Wall,Hall,Xall]=get_cluster_activtiy_by_NMF_batch(X,W,H,plotme)

[Wall,Hall,Xall]=group_W_H(X,W,H);
Wall=cell2mat(Wall);Hall=cell2mat(Hall);Xall=cell2mat(Xall);
% Wall(Wall<0)=0;
% Wall(:,sum(Wall>0,1)<4)=[];
% Hall=get_h_main(Xall,Wall);

% Wall(Wall<1e-5)=0;
% kill_in=sum(Wall>0,1)<4;
% Wall(:,kill_in)=[];
% Hall(kill_in,:)=[];


if (plotme)
        wt=squeeze(mean(Wall,3));
        [perm1,perm2]=sort_w(wt,Hall,Xall);
        figure; SimpleWHPlot_PV(wt(perm1,perm2),Hall(perm2,:),Xall(perm1,:));       
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
        w=catpad(2,zeros(size(w,1),a),w);
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

