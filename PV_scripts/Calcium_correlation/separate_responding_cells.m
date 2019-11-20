function [responding_neuron]=separate_responding_cells(obj,hypno)
%[out1,out2,phist1,phist2]=separate_responding_cells(neuron.S,neuron.S(:,1:600*5.01),neuron.S(:,5.01*601:5.01*1200));
sf=5.01;
t{1,1}=moving_mean(obj(:,1:600*sf),5.01,2,1/5.01,0);      %HC time
t{2,1}=moving_mean(obj(:,600*sf+1:1200*sf),5.01,2,1/5.01,0);    %Ctx A pre shock
t{3,1}=moving_mean(obj(:,1200*sf+1:1500*sf),5.01,2,1/5.01,0);   %Ctx A post shock
sleepdat=separate_by_sleep(moving_mean(obj(:,1500*sf+1:10500*sf),sf,2,1/sf,0),hypno(1500*sf+1:10500*sf));%Consolidation
t{4,1}=sleepdat.wake;  %Consolidation wake LT
t{5,1}=sleepdat.rw;  %Consolidation wake HT
t{6,1}=sleepdat.rem;  %Consolidation REM
t{7,1}=sleepdat.nrem;  %Consolidation NREM
t{8,1}=moving_mean(obj(:,10500*sf+1:11100*sf),5.01,2,1/5.01,0); %Retrival Ctx A
t{9,1}=moving_mean(obj(:,11100*sf+1:11700*sf),5.01,2,1/5.01,0); %New context C


responding_neuron(1:size(obj,1),1:9)=0;

for i=2:9
P=Block_boostrap(t{1,1},t{i,1},100,1000,1);
[ ind_temp, ~] = FDR( P, 0.05, 0);
responding_neuron(ind_temp,i)=1;
end
stop=2;
if stop==1
out1=obj(ind{i},:);
out2=obj;
out2(ind{i},:)=[];
out1=moving_mean(out1,5.01,2,1/5.01,0);
out2=moving_mean(out2,5.01,2,1/5.01,0);


phist=[moving_mean(t{1,1},5.01,60,5,0),moving_mean(t{i,1},5.01,60,5,0)];

phist1=phist(ind{i},:);
phist2=phist;
phist2(ind{i},:)=[];
end



