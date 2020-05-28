function Diss=convergance_performance_cluster_NMF(temp)
% Diss=convergance_performance_cluster_NMF(temp);
clear textprogressbar
numfits=10;


upd = textprogressbar(numfits); 
total_k=1;

    
   for ii = 1:numfits
        upd(ii);
        [Ws{ii},Hs{ii}]=cluster_NMF(temp,0);
        size(Ws{ii},2);
   end
    inds = nchoosek(1:numfits,2);
    for i = 1:size(inds,1) % consider using parfor for larger numfits
        Diss(i) = DISS_PV(Hs{inds(i,1)},Ws{inds(i,1)},Hs{inds(i,2)},Ws{inds(i,2)});
    end
    


%% Plot Diss and choose K with the minimum average diss.
figure,
plot(1:total_k,Diss,'ko'), hold on
h1 = plot(1:total_k,median(Diss,1),'k-','linewidth',2);
xlabel('K')
ylabel('Diss')
