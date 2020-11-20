function [b,A]=simulate_spike_activity(mice_sleep,pat_n,noise_mul)
% [b,p]=simulate_spike_activity(mice_sleep);
len=3000;
str=1500000;
neurons=40;
t=round(linspace(neurons,2800,10));  %% pattern occurance
jit=3; %jitter need to be odd


X=mice_sleep(:,[1,2,3,8,9]);
X=[catpad(2,X{1,:});catpad(2,X{2,:});catpad(2,X{3,:})];
%% Get random amplitudes
a=X(:);
a(a==0)=[];
[d,xi] = ksdensity(a);
d=cumsum(d)/sum(d);
d=unique(d);
xi=linspace(0,max(xi),size(d,2));
a=rand(size(X,1),len);
a=interp1(d,xi,a, 'linear');
a=datasample(a,neurons);

%% Get bursting probaiblity
f1=get_burst_rate(X);

%% create random activity without bursts (inter burst activity
Op=mean(X>0,2);
Op=datasample(Op,neurons);

Bp=get_Bp(sum(f1-1),Op);
Bp=datasample(Bp,neurons);
 
 
% Bp=Op/(1+mean(f1));  % calculated inter-burst activity
F=rand(neurons,len);
p = randperm(neurons,pat_n);

F(p,t)=F(p,t)/str;
F=(F/noise_mul)<Bp;

%% add bursting probability.
w = conv2(1,(f1-1),F);
w=w.*Bp;

w=(w(:,1:len)*5-rand(neurons,len))>0;
w=circshift_columns(w',ones(1,size(w,1)))';
z=F+w;
% get_burst_rate(z);

%% Add amplitudes
z=a.*z;
z=add_jitter(z,jit);

%% Bin data;
b=bin_data(z,5,2); 
A=zeros(size(b,1),1);
A(p)=mean(b(p,:),2);
end

function Bp=get_Bp(m,Op);

for i=1:size(Op)
    Bp(i,1)=max(roots([m 1 -Op(i)]));
end
end

function out=add_jitter(z,jit)

shuf=(randi(1+2*jit,1,size(z,1))-(2*jit-1));
out=circshift_columns(z',shuf)';


end







