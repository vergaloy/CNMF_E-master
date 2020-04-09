clear textprogressbar
numfits=50;
textprogressbar('calculating... '); 

k=6;
   for i = 1:numfits
        textprogressbar((i/numfits)*100);
        [Ws{i},Hs{i},~]=Get_seqNMF(C,[1,2,4,5,6,7,8,9],k,0.99,0);
   end
    inds = nchoosek(1:numfits,2);
    parfor i = 1:size(inds,1) % consider using parfor for larger numfits
        Diss(i) = DISS_PV(Hs{inds(i,1)},Ws{inds(i,1)},Hs{inds(i,2)},Ws{inds(i,2)});
    end
 textprogressbar('done');   
try
save('seqNMF_convergance_dev.mat')
catch
    disp('no saved');
end
%% Plot Diss and choose K with the minimum average diss.
figure,
plot(k,Diss,'ko'), hold on
h1 = plot(k,median(Diss,1),'k-','linewidth',2);
xlabel('K')
ylabel('Diss') 
