function [X,pattern]=NMF_simulated_data(N,T,P,C,PF,F,NF)
%X=NMF_simulated_data(20,10000,3,[3 5],0.005,0.01);
X(1:N,1:T)=0;
Pat(1:N,1)=0;
for p=1:P
rand_cells=randi(C);
pattern{p}=randsample(N,rand_cells);
Pat(pattern{p},1)=1;
X(pattern{p},:)=round(ones(rand_cells,1)*poissrnd(PF,1,T));
end
noise(1:N,1:T)=0;
Pattern_cells=sum(Pat,1);
no_Pattern=size(Pat,1)-sum(Pat,1);
noise(logical(Pat),:)=poissrnd(F-PF,Pattern_cells,T)*1;
noise(logical(-(Pat-1)),:)=poissrnd(NF,no_Pattern,T)*1;
X=X+noise;

