function optimize_K(C)
% optimize_K(D)
clear textprogressbar
numfits=5;
textprogressbar('calculating... '); 

total_k=1;

    
   for ii = 1:numfits
        textprogressbar((ii/numfits)*100);
        [Ws{ii},Hs{ii},~]=Get_seqNMF(C,[1,2],0.99,0);
        size(Ws{ii},2)
   end
    inds = nchoosek(1:numfits,2);
    for i = 1:size(inds,1) % consider using parfor for larger numfits
        Diss(i) = DISS_PV(Hs{inds(i,1)},Ws{inds(i,1)},Hs{inds(i,2)},Ws{inds(i,2)});
    end
    


%% Plot Diss and choose K with the minimum average diss.
figure,
plot(1:total_k,Diss,'ko'), hold on
h1 = plot(1:total_k,median(Diss,1),'k-','linewidth',2);
legend(h1, {'median Diss'})
xlabel('K')
ylabel('Diss')
