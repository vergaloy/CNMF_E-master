clear all
%Create Test Data fo NMF
rng('default') % For reproducibility
Frequency=0.05;
participation=20;
duration=3000;
P1 = round(poissrnd(participation,5,1)*poissrnd(Frequency,1,duration));   %sequence 1
P2 = round(poissrnd(participation,3,1)*poissrnd(Frequency,1,duration));    %sequence 2 overlapping with sequence 1
P3 = round(poissrnd(participation,3,1)*poissrnd(Frequency,1,duration));     %sequence 3
PR=[];  % other random sequences 
for i=1:15
    PR=[PR;round(poissrnd(normrnd(participation,2),1,1)*poissrnd(Frequency,1,duration))];
end
X(1:9,1:duration)=0;
X(1:5,:)=P1;
X(4:6,:)=X(4:6,:)+P2;
X(5,:)=X(5,:)+P3(1,:);
X(8:9,:)=X(8:9,:)+P3(2:3,:);
X=[X;PR];
noise=poissrnd(Frequency*0.5,size(X,1),duration)*participation*0.5; 
X=X+noise;



figure
imagesc(X);
colormap('hot')
clearvars participation Frequency i
[W0,H0,~] = nnmf(X,1,'replicates',100,'algorithm','mult');