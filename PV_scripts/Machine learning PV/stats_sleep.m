function stats_sleep(X,hyp,N,sf,bin)
% stats_sleep(D{1,4},hyp,N,5,1)
hyp=bin_data(hyp,sf,bin);
[T,S]=total_sleep_binned(hyp,X,N);
T=T(:,[6,4,1]);
[ci,p]=bootstrap(T);
end







function [P,S]=total_sleep_binned(hypno,X,N);
for i=1:size(X)
    temp=X(i,:);
    h=hypno(N(i),:);
    P(:,i)=get_sleep_binned(temp,h);
    S(:,i)=get_sleep_binned_sum(temp,h);    
end
P=P';
S=S';
end


function O=get_sleep_binned(temp,h)
R=temp;R(h~=1)=[];R=mean(R);
H=temp;H(h~=0.25)=[];H=mean(H);
W=temp;W(h~=0)=[];W=mean(W);
N=temp;N(h~=0.5)=[];N=mean(N);
S=temp;S(h<0.5)=[];S=mean(S);
V=temp;V(h>0.4)=[];V=mean(V);
O=[R;H;W;N;S;V];
end

function O=get_sleep_binned_sum(temp,h)
R=temp;R(h~=1)=[];R=sum(R);
H=temp;H(h~=0.25)=[];H=sum(H);
W=temp;W(h~=0)=[];W=sum(W);
N=temp;N(h~=0.5)=[];N=sum(N);
S=temp;S(h<0.5)=[];S=sum(S);
V=temp;V(h>0.4)=[];V=sum(V);
O=[R;H;W;N;S;V];
end




