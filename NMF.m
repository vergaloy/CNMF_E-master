clear all
%NMF minimize the function e=X-W*H
%Create Test Data
Frequency=0.05;
participation=6;
P1 = round(poissrnd(participation,5,1)*poissrnd(Frequency,1,500));   %sequence 1
P2(5,500)=zeros;
P2(1:3,:) = round(poissrnd(participation,3,1)*poissrnd(Frequency,1,500));    %sequence 2

noise=rand(5,500)*participation;       %Add noise
X(1:5,1:500)=P1+P2+noise/5;

%Plot Original data
figure;
subplot 121;
imagesc(P1)
colormap('hot')
subplot 122;
imagesc(P2)
colormap('hot')
figure
imagesc(X);
colormap('hot')

N=size(X,1)*size(X,2);
AICc(1:3)=0;
% Find intial W H
for order=1:3
    

[W0,H0,D0] = nnmf(X,order,'replicates',1000);

k=size(H0,2)*size(H0,1); 
AICc(order)=N*log(D0)/2+k+k*(k+1)/(N-k-1);  %compute Akaike's Information Criterion              
end  
[~,K]=min(AICc);  % Find optimal number of patterns
[W0,H0,D0] = nnmf(X,K,'replicates',1000);

%Get optimal results
opt = statset('Maxiter',1000,'Display','final');
[W,H] = nnmf(X,K,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');

 %Plot predicted patterns            
P1r=W(:,1)*H(1,:);
P2r=W(:,2)*H(2,:);
figure;
subplot 121;
imagesc(P2r)
colormap('hot')
subplot 122;
imagesc(P1r)
colormap('hot')
