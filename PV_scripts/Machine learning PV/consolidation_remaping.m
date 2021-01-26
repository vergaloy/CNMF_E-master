function consolidation_remaping(data,active,Wc,pix,a)

sf=5;
bin=2;
div=10;

[out,hypno,N]=get_concantenated_data(data,sf,bin);
out=out(active,:);
h=get_h_main(out,Wc);
h=conv2(1,gausswin(5),h,'same');
h(h>0)=1;
[perm1,perm2]=sort_w(Wc,h);
figure; SimpleWHPlot_PV(Wc(perm1,perm2),h(perm2,:),out(perm1,:));

I=out;
I(reconstructPV(Wc,h)==0)=0;
I2=out;
I2(reconstructPV(Wc,h)>0)=0;

 ic=2;
B=means_binned_data(out,div);
B=B./prctile(B,95,1);
B(B>1)=1;
[~,i]=sort(mean(gradient(B),2));
figure;imagesc(B(i,:))
B=gradient(B);
% B=B(:,1)-B(:,3);
figure;imagesc(B)
[sA,sI,sT]=total_sleep_binned(hypno,I,I2,N,div);
% imagesc(squeeze(sa(2,:,:))');

B=B(pix==ic,:);
b=B(:);

S1=squeeze(sA(5,:,:))';
S1=S1(pix==ic,:);
% S=gradient(S);
S=S1(:);
fit_line(S,b);

S2=squeeze(sI(5,:,:))';
S2=S2(pix==ic,:);
% S=gradient(S);
S=S2(:);
fit_line(S,b);

S3=S2-S1;

S3=S3(:);
fit_line(S3,b);


end


function [sA,sI,sT]=total_sleep_binned(hypno,out,I,N,div);

for i=1:size(out)
    temp=out(i,:);
    temp2=I(i,:);
    h=hypno(N(i),:);
    sA(:,:,i)=get_sleep_binned(temp,h,div);
    sI(:,:,i)=get_sleep_binned(temp2,h,div);
    sT(:,:,i)=get_sleep_binned(ones(1,length(temp)),h,div);
end
end


function S=get_sleep_binned(temp,h,div);
R=temp;R(h~=1)=0;%R=cumsum(R);
H=temp;H(h~=0.25)=0;%W=cumsum(W);
W=temp;W(h~=0)=0;%W=cumsum(W);
N=temp;N(h~=0.5)=0;%N=cumsum(N);
S=temp;S(h<0.5)=0;%N=cumsum(N);
V=temp;V(h>0.4)=0;%N=cumsum(N);


S=[R;H;W;N;S;V];
S=means_binned_data(S,div);
end

function B=means_binned_data(in,bsize)
lin=round(linspace(1,size(in,2),bsize+1));
for i=1:size(lin,2)-1
B(:,i)=mean(in(:,lin(i):lin(i+1)),2);   
end    
end



function A=separate_Act(in,hypno,N)
A=[];
for i=1:max(N)
    temp=in(N==i,:);
    h=hypno(i,:);
    out=sep_by_sleep(temp,h);
    A=cat(1,A,out);
end
end


function out=sep_by_sleep(ob,h)
rem=ob;
rem(:,h~=1)=[];
rem=mean(rem,2);
rw=ob;
rw(:,h~=0.25)=[];
rw=mean(rw,2);
wake=ob;
wake(:,h~=0)=[];
wake=mean(wake,2);
nrem=ob;
nrem(:,h~=0.5)=[];
nrem=mean(nrem,2);

sleep=ob;
sleep(:,h<0.5)=[];
sleep=mean(sleep,2);

wake_all=ob;
wake_all(:,h>0.25)=[];
wake_all=mean(wake_all,2);
out=[rem,rw,wake,nrem,wake_all,sleep];
end



function I=isolate_pattern_activity(X,w)
% [out,Pa]=get_pattern_consolidation2(X,Wc);
rng('default')
h=get_h_main(X,w);
[~,active]=remove_zeros(h);
w=w(:,active);
h=h(active,:);


h=conv2(1,gausswin(5),h,'same');
h(h>0)=1;

k=sum(h,2)==0;

h(k,:)=[];

wt=squeeze(mean(w,3));
wt(:,k)=[];
% [~, ~, ~, hybrid] = helper.ClusterByFactor(w(:,:,:),1);
% L = hybrid(:,3);
[perm1,perm2]=sort_w(wt,h);

figure; SimpleWHPlot_PV(wt(perm1,perm2),h(perm2,:),X(perm1,:));
I=X;
I(reconstructPV(wt,h)==0)=0;
%     figure; SimpleWHPlot_PV(wt(perm1,perm2),h,I(perm1,:));
% figure;imagesc(I(perm1,:));caxis([0 1])
% figure;imagesc(X(perm1,:));caxis([0 1])

end


function [H]=get_h_main(X,W)
for i=1:size(W,2)
    w=W(:,i,:);
    wt=squeeze(mean(w,3));
    x=X(wt>0,:);
    w(wt==0,:,:)=[];
    x(:,isnan(sum(x,1)))=0;
    w(w>0)=1;
    x(x>0)=1;
    
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

function [data,active]=remove_zeros(data)
len=size(data,2);
active=data;
active(active~=0)=1;
active=1-mean(active,2);
active=active.^len/2;
active=active<0.05;
data=data(active,:);
end