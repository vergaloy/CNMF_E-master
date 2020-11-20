function  [mice_sleep,hyp]=group_mice_data(data)
%  [mice_sleep,hyp]=group_mice_data(data);
for i=1:size(data,1)
  temp=data{i, 1}.neuron.S;
  mice_sleep(i,:)=Separate_by_behaviour_no_bin(temp,data{i, 1}.hypno,50);
  hyp(i,:)=data{i, 1}.hypno(7501+50:52500);
end

