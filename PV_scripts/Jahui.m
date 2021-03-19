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

plot(data(1:5,:)','r');hold on;plot(data(6:10,:)','b');plot(M1','--r','LineWidth',2);plot(M2','--b','LineWidth',2);
xlabel('Bout length');ylabel('Cumulative Freezing (%)')
