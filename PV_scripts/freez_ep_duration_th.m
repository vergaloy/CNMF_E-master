function [P,CI]=freez_ep_duration_th(data)

dif=[zeros(size(data,1),1),diff(data,1,2)];
C=cumsum(dif==1,2).*data+1;
n=size(data,2);
for i=1:size(C,1)
 v=accumarray(C(i,:)',1)+1;
 v=sort(v(2:end));
 o(i,:)=cumulative_bouts(v);
 PDF(i,:)=count_episodes_jahui(v);   
 V(i,:) =freez_vs_bout_time(v,n);
end

% plot_yahui(Cu)
P0=Jahui(PDF);
P=D_paired(PDF);
P2=Jahui(o); % classic Jahui method
plot_yahui(V)
CI=get_CI(V(1:5,1:23),V(6:10,1:23));
end

function P=D_paired(data)
[~,I]=max(abs(data(1:5,:)-data(6:10,:)),[],2);
d=data(1:5,:)-data(6:10,:);
for i=1:length(I)
D(i)=d(i,I(i));
end
figure;plot(d(1:5,:)','r');
xlabel('Freezing episode duration (frames)');ylabel('delta CPDF')

[~,P] = ttest(D);

end



function o=cumulative_bouts(v)
v=v/max(v)*100;
x=linspace(1,length(v),1000);
o = interp1(1:length(v),v,x);
end


function C=count_episodes_jahui(v);

for i=1:150
    cou(i)=length(find(v==i));
end
C=cumsum(cou)/sum(cou);

end


function F=freez_vs_bout_time(v,n)

for k=0:300
temp=v(v>k);
F(k+1)=sum(temp)/n*100;
end

end


function plot_yahui(V,n)

if ~exist('n','var')
    n=size(V,2);
end
n2=size(V,1)/2;
M1=mean(V(1:n2,:),1);
M2=mean(V(n2+1:2*n2,:),1);

figure;plot(V(1:n2,1:n)','r');hold on;plot(V(n2+1:2*n2,1:n)','b');plot(M1(1:n)','--r','LineWidth',2);plot(M2(1:n)','--b','LineWidth',2);
xlabel('Freezing episode duration threshold (Frames)');ylabel('Freezing (%)')
end

function CI=get_CI(obj1,obj2);

for i=1:size(obj1,2)
    temp1=obj1(:,i);
    temp1(isnan(temp1))=[];
    temp2=obj2(:,i);
    temp2(isnan(temp2))=[];
    surr=[temp1,temp2];
    parfor s=1:10000
        temp=datasample(surr,size(surr,1));
        sim(s,i)= mean(temp(:,1),1)-mean(temp(:,2),1);
    end
    clear surr
end

CI=[nanmean(sim,1)',prctile(sim,97.5,1)',prctile(sim,2.5,1)'];
end




function P=Jahui(data);
% Jahui(PDF);
M1=mean(data(1:5,:),1);
M2=mean(data(6:10,:),1);
D=max(abs(M1-M2));

sim=10000;
for s=1:sim
    X=data(randperm(size(data,1)),:);
    S1=mean(X(1:5,:),1);
    S2=mean(X(6:10,:),1);
    D_perm(s)=max(abs(S1-S2));
end

D_perm=sort(D_perm);

P=1-(find(D_perm>D,1)+1)/(sim+1);

figure;plot(data(1:5,:)','r');hold on;plot(data(6:10,:)','b');plot(M1','--r','LineWidth',2);plot(M2','--b','LineWidth',2);
xlabel('Freezing episode duration (frames)');ylabel('CPDF')
end
