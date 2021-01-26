function ensamble_vs_no_ensemble_stat(X,H,W,D,si)

k=0;

All=[];
P=[];
nP=[];
for i=1:size(D,2)
    
    x=X(:,k+1:k+size(D{1,i},2));
    w=W;
    h=H(:,k+1:k+size(D{1,i},2));
    k=k+size(D{1,i},2);
    
    p=x;
    p(w*h==0)=0;
    np=x;
    np(w*h>0)=0;
    H_T(:,i)=mean(h,2);
    if (i~=4)
        All=[All,mean(x,2)];
        P=[P,mean(p,2)];
        nP=[nP,mean(np,2)];
    else
        x=means_binned_data(x,10);
        p=means_binned_data(p,10);
        np=means_binned_data(np,10);
        All=[All,x];
        P=[P,p];
        nP=[nP,np];
    end
    
end

Alls=All./prctile(All,95,1);
Alls(Alls>1)=1;

Ps=P./prctile(P,95,1);
Ps(Ps>1)=1;

nPs=nP./prctile(nP,95,1);
nPs(nPs>1)=1;

ix=cluster_mean_activities(Alls(si>0,[1,2,3,14,15]));
ix=cluster_mean_activities(nP(:,[1,2,3,14,15]));

s=1;
bootstrap(Alls(si==s,[1,2,3,14,15]))
bootstrap(Ps(si==s,[1,2,3,14,15]))
bootstrap(nPs(si==s,[1,2,3,14,15]))




[ci,p]=bootstrap(Alls(si==s,:))
[ci,p]=bootstrap(Ps(si==s,:))
[ci,p]=bootstrap(nPs(si==s,:))


[ci,p]=bootstrap(H_T(:,[1,2,3,5,6]),5)

p=P(:,[1,2,3,14,15]);
I=sum(p,2)~=0;

[ci,p]=bootstrap_dif(P(si==2,[1,2,3,14,15]),All(si==2,[1,2,3,14,15]))


bootstrap(All)
bootstrap(P)
bootstrap(nP)

end



function B=means_binned_data(in,bsize)
lin=round(linspace(1,size(in,2),bsize+1));
for i=1:size(lin,2)-1
    B(:,i)=mean(in(:,lin(i):lin(i+1)),2);
end
end
