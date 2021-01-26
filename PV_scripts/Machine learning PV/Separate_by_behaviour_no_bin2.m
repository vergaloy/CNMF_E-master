function C=Separate_by_behaviour_no_bin2(obj,remove_first)
% C=Separate_by_behaviour_no_bin(neuron.S,hypno,50);

i=0;


temp=full(obj);

i=i+1;
C{i}=temp(:,1+remove_first:3000);
i=i+1;
C{i}=temp(:,3001+remove_first:6000);
i=i+1;
C{i}=temp(:,6001+remove_first:7500);
i=i+1;
C{i}=temp(:,7501+remove_first:52500);
i=i+1;
C{i}=temp(:,52501+remove_first:55500);
i=i+1;
C{i}=temp(:,55501+remove_first:58500);

