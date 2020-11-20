function [Out,H,D,E]=NMF_Akaike(X)


max_order=min([size(X,1),size(X,2)]);
N=size(X,1)*size(X,2);
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);

for r=1:max_order 
[W0,H0,~] = nnmf(X,r,'replicates',100,'algorithm','mult');
[W,H,~] = nnmf(X,r,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als'); 
order=size(W,2);                          
RSS=sqrt(sum((X-W*H).^2,'all'));
k=size(X,1)*order+size(X,2)*order; % sum(S)+
AICc(order)=N*log(RSS/N)+2*k+(2*k*(k+1))/(N-k-1); %  %compute Akaike's Information Criterion              
end  

[~,K]=nanmin(AICc);  % Find optimal number of patterns

[W0,H0,~] = nnmf(X,K,'replicates',1000);

[w,h] = seqNMF(X,'K',5, 'L', 1,'lambda', 0.5,'maxiter',100,'showplot',1);


numfits=5;
   for ii = 1:numfits
       ii
        [Ws{ii},Hs{ii},~]=seqNMF(X,'K',ii, 'L', 1,'lambda', 0.01,'maxiter',100,'showplot',0);  
   end
    inds = nchoosek(1:numfits,2);
    for i = 1:size(inds,1) % consider using parfor for larger numfits
        Diss(i) = DISS_PV(Hs{inds(i,1)},Ws{inds(i,1)},Hs{inds(i,2)},Ws{inds(i,2)});
    end





%Get optimal results
opt = statset('Maxiter',1000,'TolFun', 1e-4,'TolX',1e-4);
[W,H,D] = nnmf(X,K,'w0',W0,'h0',H0,...
                 'options',opt,...
                 'algorithm','als');

        [~, ~, ~, hybrid] = helper.ClusterByFactor(w(:,:,:),1);
    indSort = hybrid(:,3);      
     figure; SimpleWHPlot(w(indSort,:,:),h,X(indSort,indSort)); title('SeqNMF factors, with raw data')
    
             
