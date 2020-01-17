function cut_sakthi_data(obj)
%cut_sakthi_data(neuron.S)
obj=full(obj);
%obj(obj>0)=1;
bin=1;
shift=0.5;


hc=moving_mean(obj(:,1:3000),10,bin,shift,0);
obj(:,1:3004)=[];

n=1;
bg(:,:,n)=moving_mean(obj(:,1:1800),10,bin,shift,0);
obj(:,1:1800)=[];
t(:,:,n)=moving_mean(obj(:,1:200),10,bin,shift,0);
obj(:,1:200)=[];
g(:,:,n)=moving_mean(obj(:,1:180),10,bin,shift,0);
obj(:,1:180)=[];
s(:,:,n)=moving_mean(obj(:,1:20),10,bin,shift,0);
obj(:,1:20)=[];
[z,mu,sigma]=zscore(bg(:,:,n)');
z=z';
mu=mu';
sigma=sigma';
all=[bg(:,:,n),t(:,:,n),t(:,:,n),s(:,:,n)];
av=mean(s(:,:,n),2);
[~,I]=sort(av,'descend');
all=all(I,:);
figure
imagesc(all)

n=2;
bg(:,:,n)=moving_mean(obj(:,1:1800),10,bin,shift,0);
obj(:,1:1800)=[];
t(:,:,n)=moving_mean(obj(:,1:200),10,bin,shift,0);
obj(:,1:200)=[];
g(:,:,n)=moving_mean(obj(:,1:180),10,bin,shift,0);
obj(:,1:180)=[];
s(:,:,n)=moving_mean(obj(:,1:20),10,bin,shift,0);
obj(:,1:20)=[];



n=3;
bg(:,:,n)=moving_mean(obj(:,1:1800),10,bin,shift,0);
obj(:,1:1800)=[];
t(:,:,n)=moving_mean(obj(:,1:200),10,bin,shift,0);
obj(:,1:200)=[];
g(:,:,n)=moving_mean(obj(:,1:180),10,bin,shift,0);
obj(:,1:180)=[];
s(:,:,n)=moving_mean(obj(:,1:20),10,bin,shift,0);
obj(:,1:20)=[];


n=4;
bg(:,:,n)=moving_mean(obj(:,1:1800),10,bin,shift,0);
obj(:,1:1800)=[];
t(:,:,n)=moving_mean(obj(:,1:200),10,bin,shift,0);
obj(:,1:200)=[];
g(:,:,n)=moving_mean(obj(:,1:180),10,bin,shift,0);
obj(:,1:180)=[];
s(:,:,n)=moving_mean(obj(:,1:20),10,bin,shift,0);
obj(:,1:20)=[];


n=5;
bg(:,:,n)=moving_mean(obj(:,1:1800),10,bin,shift,0);
obj(:,1:1800)=[];
t(:,:,n)=moving_mean(obj(:,1:200),10,bin,shift,0);
obj(:,1:200)=[];
g(:,:,n)=moving_mean(obj(:,1:180),10,bin,shift,0);
obj(:,1:180)=[];
s(:,:,n)=moving_mean(obj(:,1:20),10,bin,shift,0);
obj(:,1:20)=[];

all=[g(:,:,2),g(:,:,3),g(:,:,4),g(:,:,5)];
av=mean(g(:,:,5),2);
[~,I]=sort(sum(all,2),'descend');
all=[all,s(:,:,1),s(:,:,2),s(:,:,3),s(:,:,4),s(:,:,5)];
all=all(I,:);
figure
imagesc(all)


temp=[s(:,:,1),s(:,:,2),s(:,:,3),s(:,:,4),s(:,:,5)];
temp=temp./rms(temp,2);
temp(isnan(temp))=0;
temp(isinf(temp))=0;


[W_R,W,H,D]=NMF(temp,1,3);
[A,I]=sort(W(:,1),'descend');
temp=[t(:,:,1),t(:,:,2),t(:,:,3),t(:,:,4),t(:,:,5)];
temp=[temp,s(:,:,1),s(:,:,2),s(:,:,3),s(:,:,4),s(:,:,5)];
temp=temp(I,:);
figure
imagesc(temp)

ctx_a=moving_mean(obj(:,1:3000),10,bin,shift,0);
obj(:,1:3000)=[];
ctx_c=moving_mean(obj(:,1:3600),10,bin,shift,0);
obj(:,1:3600)=[];
dummy=1;
