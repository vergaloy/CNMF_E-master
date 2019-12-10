function [responding_neuron]=separate_responding_cells(obj,hypno)
%[out1,out2,phist1,phist2]=separate_responding_cells(neuron.S,neuron.S(:,1:600*5.01),neuron.S(:,5.01*601:5.01*1200));
sf=5.01;
obj=full(obj);
obj(obj>0)=1;
obj=moving_mean(obj,5.01,100,1/5.01,0);
obj=obj./rms(obj,2);

t{1,1}=obj(:,1:600*sf);      %HC time
t{2,1}=obj(:,600*sf+1:1200*sf);    %Ctx A pre shock
t{3,1}=obj(:,1200*sf+1:1500*sf);   %Ctx A post shock
sleepdat=separate_by_sleep(obj(:,1500*sf+1:10500*sf),hypno(1500*sf+1:10500*sf));%Consolidation
t{4,1}=sleepdat.wake;  %Consolidation wake LT
t{5,1}=sleepdat.rw;  %Consolidation wake HT
t{6,1}=sleepdat.rem;  %Consolidation REM
t{7,1}=sleepdat.nrem;  %Consolidation NREM
t{8,1}=obj(:,10500*sf+1:11100*sf); %Retrival Ctx A
t{9,1}=obj(:,11100*sf+1:11700*sf); %New context C


responding_neuron(1:size(obj,1),1)=0;


P=Block_boostrap(t{2,1},t{3,1},100,1000,2);
[ ind_temp, ~] = FDR( P, 0.05, 0);
responding_neuron(ind_temp,1)=1;

A=t{2,1};
B=t{3,1};

C=[A(logical(responding_neuron),:),B(logical(responding_neuron),:)];

imagesc(C);





