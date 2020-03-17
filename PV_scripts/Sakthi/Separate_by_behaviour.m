function [C]=Separate_by_behaviour(obj,hypno)
% [C]=Separate_by_behaviour(neuron.S,hypno);

sf=5;
binz=2;
i=0;
remove_first=50;

temp=full(obj);

i=i+1;
C{i}=temp(:,1+remove_first:3000);
C{i}=bin_data(full(C{i}),sf,binz);

i=i+1;
C{i}=temp(:,3001+remove_first:6000);
C{i}=bin_data(full(C{i}),sf,binz);

i=i+1;
C{i}=temp(:,6001+remove_first:7500);
C{i}=bin_data(full(C{i}),sf,binz);

sleepdata=separate_by_sleep(temp(:,7501+remove_first:52500),hypno(7501+remove_first:52500));

i=i+1;
C{i}=sleepdata.rem;
C{i}=bin_data(full(C{i}),sf,binz);

i=i+1;
C{i}=sleepdata.rw;
C{i}=bin_data(full(C{i}),sf,binz);

i=i+1;
C{i}=sleepdata.wake;
C{i}=bin_data(full(C{i}),sf,binz);

i=i+1;
C{i}=sleepdata.nrem;
C{i}=bin_data(full(C{i}),sf,binz);

i=i+1;
C{i}=temp(:,52501+remove_first:55500);
C{i}=bin_data(full(C{i}),sf,binz);

i=i+1;
C{i}=temp(:,55501+remove_first:58500);
C{i}=bin_data(full(C{i}),sf,binz);
