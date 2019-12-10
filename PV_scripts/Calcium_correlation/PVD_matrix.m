function PV=PVD_matrix(obj,hypno)
sf=5.01;
obj=full(obj);
obj(obj>0)=1;


t{1,1}=moving_mean(obj(:,1:600*sf),5.01,30,15,0);      %HC time
t{2,1}=moving_mean(obj(:,600*sf+1:1200*sf),5.01,30,15,0);    %Ctx A pre shock
t{3,1}=moving_mean(obj(:,1200*sf+1:1500*sf),5.01,30,15,0);   %Ctx A post shock
sleepdat=separate_by_sleep(obj(:,1500*sf+1:10500*sf),hypno(1500*sf+1:10500*sf));%Consolidation
t{4,1}=moving_mean(sleepdat.wake,5.01,30,15,0);  %Consolidation wake LT
t{5,1}=moving_mean(sleepdat.rw,5.01,30,15,0);  %Consolidation wake HT
t{6,1}=moving_mean(sleepdat.rem,5.01,30,15,0);  %Consolidation REM
t{7,1}=moving_mean(sleepdat.nrem,5.01,30,15,0);  %Consolidation NREM
t{8,1}=moving_mean(obj(:,10500*sf+1:11100*sf),5.01,30,15,0); %Retrival Ctx A
t{9,1}=moving_mean(obj(:,11100*sf+1:11700*sf),5.01,30,15,0); %New context C




r=size(t,1);
PV(1:r,1:r)=0;
comb=nchoosek(1:9,2);

for i=1:size(comb,1)
    PV(comb(i,1),comb(i,2))=PVD_Bhattacharyya(t{comb(i,1)},t{comb(i,2)});   %replase 5 with sizesize(A{comb(i,1)},1)
end
PV=PV+PV';

figure
imagesc(PV);
[Y,eigvals]=cmdscale(PV);
B = cumsum(eigvals);
B=B/max(B)*100;
B
conditions={'HC','A','Post Shock','Low Theta','High Theta','REM','NREM','Retrival','C'};
figure
plot(Y(:,1),Y(:,2),'ro', 'MarkerSize',10);
text(Y(:,1),Y(:,2),conditions);
xlim([-0.6 0.8]) 
ylim([-0.6 0.8]) 

%colormap(jet)