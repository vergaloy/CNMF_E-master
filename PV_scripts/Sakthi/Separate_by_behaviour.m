function [C]=Separate_by_behaviour(neuron,hypno);
sf=5;
binz=2;
ts=1;
i=0;

i=i+1;
C{i}=neuron.S(:,1:3000);
C{i}=moving_mean(C{i},sf,binz,ts,0);

i=i+1;
C{i}=neuron.S(:,3001:6000);
C{i}=moving_mean(C{i},sf,binz,ts,0);

i=i+1;
C{i}=neuron.S(:,6001:7500);
C{i}=moving_mean(C{i},sf,binz,ts,0);

sleepdata=separate_by_sleep(neuron.S(:,7501:52500),hypno(7501:52500));

i=i+1;
C{i}=sleepdata.rem;
C{i}=moving_mean(C{i},sf,binz,ts,0);

i=i+1;
C{i}=sleepdata.rw;
C{i}=moving_mean(C{i},sf,binz,ts,0);

i=i+1;
C{i}=sleepdata.wake;
C{i}=moving_mean(C{i},sf,binz,ts,0);

i=i+1;
C{i}=sleepdata.nrem;
C{i}=moving_mean(C{i},sf,binz,ts,0);

i=i+1;
C{i}=neuron.S(:,52501:55500);
C{i}=moving_mean(C{i},sf,binz,ts,0);

i=i+1;
C{i}=neuron.S(:,55501:58500);
C{i}=moving_mean(C{i},sf,binz,ts,0);
