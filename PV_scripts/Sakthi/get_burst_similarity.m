function get_burst_similarity(neuron)

HC=neuron.S(:,1:3000);
A=neuron.S(:,3001:6000);
S=neuron.S(:,6001:7500);
Ret=neuron.S(:,52501:53500);
C=neuron.S(:,53501:58500);

HC=moving_mean(HC,5,10,1,0);
A=moving_mean(A,5,10,1,0);
S=moving_mean(S,5,10,1,0);
Ret=moving_mean(Ret,5,10,1,0);
C=moving_mean(C,5,10,1,0);

temp=HC;
temp(temp>0)=1;
t=sum(temp,1);
HC(:,t<rms(t)*2)=[];

temp=A;
temp(temp>0)=1;
t=sum(temp,1);
A(:,t<rms(t)*2)=[];

temp=S;
temp(temp>0)=1;
t=sum(temp,1);
S(:,t<rms(t)*2)=[];

temp=Ret;
temp(temp>0)=1;
t=sum(temp,1);
Ret(:,t<rms(t)*2)=[];

temp=C;
temp(temp>0)=1;
t=sum(temp,1);
C(:,t<rms(t)*2)=[];

[HC,~,~,~]=NMF(HC,1,3);
[A,~,~,~]=NMF(A,1,3);
[S,~,~,~]=NMF(S,1,3);
[Ret,~,~,~]=NMF(Ret,1,3);
[C,~,~,~]=NMF(C,1,3);


all=[HC,A,S,Ret,C];
all=all./max(all,[],1);
[~,I]=sort(all(:,2),1,'descend');
all=all(I,:);
dummy=1

