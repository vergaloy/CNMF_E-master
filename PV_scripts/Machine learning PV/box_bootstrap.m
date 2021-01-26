function IX=box_bootstrap(D,win,hypno,N,sf,bin)
% IX=box_bootstrap(D,10,hyp,N,5,1)
%  X=D{1,4};
%  hypno=bin_data(hypno,sf,bin);
% [P]=total_sleep_binned(hypno,X,1,N);
% 
% W=squeeze(P(6,:,:))';
% 
% for i=1:size(W,1)
%     temp=W(i,:);
%     temp(isnan(temp))=[];
%     O(i,:)=temp(end-599:end);
% end
% 
% D{1,4}=O;
for i=1:size(D,2)
        d=D{1,i};
        S(:,:,i)=get_mean_replicates(d,win);
end

for i=2:size(D,2)
Dif=S(:,:,i)-S(:,:,1);
ix=(prctile(Dif,2.5,2).*prctile(Dif,97.5,2)>0).*(prctile(Dif,2.5,2)>0)-(prctile(Dif,97.5,2)<0).*(mean(Dif,2)~=0);
IX(:,i)=ix;
end
sum(IX(:,2:3)==1,1)
sum(IX(:,2:3)==-1,1)

X=[D{1,1},D{1,2},D{1,3}];temp=X(IX(:,2)==1,:);
temp=bin_data(temp,1,10);
mid(1)=size(D{1,1},2)/10;
mid(2)=mid(1)+size(D{1,2},2)/10;
[~,I]=sort(mean(temp(:,mid:end),2),'descend');
figure; imagesc(temp(I,:));colormap('hot');caxis([0 0.2]);xline(mid(1),'--c','LineWidth',2);xline(mid(2),'--c','LineWidth',2)

%%=================
for i=2:size(D,2)
Dif=S(:,:,i)-S(:,:,4);
ix=(prctile(Dif,2.5,2).*prctile(Dif,97.5,2)>0).*(prctile(Dif,2.5,2)>0)-(prctile(Dif,97.5,2)<0).*(mean(Dif,2)~=0);
% figure;imagesc(X(ix==1,:))
IX(:,i)=ix;
end

sum(IX==1,1)
sum(IX==-1,1)

X=[D{1,4},D{1,5},D{1,6}];temp=X(IX(:,2)==-1,:);
temp=bin_data(temp,1,10);
mid(1)=size(D{1,4},2)/10;
mid(2)=mid(1)+size(D{1,5},2)/10;
[~,I]=sort(mean(temp(:,mid:end),2),'descend');
figure; imagesc(temp(I,:));colormap('hot');caxis([0 0.2]);xline(mid(1),'--c','LineWidth',2);xline(mid(2),'--c','LineWidth',2)



end
function S=get_mean_replicates(data,win)
parfor s=1:10000
    S(:,s)=mean(get_sample(data,win),2);
end

end


function t=get_sample(data,win)
x=floor(linspace(0,size(data,2),round(size(data,2)/win)+1));
n=size(x,2)-1;
s=[];
for i=1:n
    r=randperm(n,1);
    temp=data(:,x(r)+1:x(r+1));
    s=[s,temp];
end
t=mean(s,2);
end

function [P]=total_sleep_binned(hypno,X,div,N);
for i=1:size(X)
    temp=X(i,:);
    h=hypno(N(i),:);
    P(:,:,i)=get_sleep_binned(temp,h,div);

end
end


function O=get_sleep_binned(temp,h,div)
R=temp;R(h~=1)=nan;%R=cumsum(R);
H=temp;H(h~=0.25)=nan;%W=cumsum(W);
W=temp;W(h~=0)=nan;%W=cumsum(W);
N=temp;N(h~=0.5)=nan;%N=cumsum(N);
S=temp;S(h<0.5)=nan;%N=cumsum(N);
V=temp;V(h>0.4)=nan;%N=cumsum(N);
O=[R;H;W;N;S;V];

end
