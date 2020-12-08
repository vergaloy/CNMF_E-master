function consolidation_remaping(data,active,Wc,pix)

sf=5;
bin=1;

[out,hypno,N]=get_concantenated_data(data,sf,bin);
out=out(active,:);
N=N(active,:);
I=isolate_pattern_activity(out,Wc);


get_means_by_bins(I,hypno,N,pix,4)
A=separate_Act(I,hypno,N);




end


function get_means_by_bins(in,hypno,N,pix,bsize)

lin=round(linspace(1,size(in,2),bsize+1));

for i=1:size(lin)-1;
temp=in(:,lin(i):lin(i+1));
ht=hypno(:,lin(i):lin(i+1));
at=separate_Act(temp,ht,N);

pCI2=compare_cell_ensambles_activity_proportion(at,pix,1);

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
out=[rem,rw,wake,nrem];
end


function [out,hypno,N]=get_concantenated_data(data,sf,bin)
out=[];
hypno=[];
N=[];
for i=1:size(data,1)   
    temp=full(data{i, 1}.neuron.S);
    n=ones(size(temp,1),1)*i;
    hyp=data{i, 1}.hypno;     
    temp=temp(:,7501:52500);
    hyp=hyp(7501:52500);   
    temp=bin_data(temp,sf,bin); 
    hyp=bin_data(hyp,sf,bin);        
    out=cat(1,out,temp);
    hypno=cat(1,hypno,hyp);
    N=cat(1,N,n);
end
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