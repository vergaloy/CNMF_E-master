function  [mice_sleep,hyp]=group_mice_data(data)
%  [mice_sleep,hyp]=group_mice_data(data);
for i=1:size(data,1)
  mice_sleep(i,:)=Separate_by_behaviour_no_bin(data{i, 1}.neuron.S,data{i, 1}.hypno,50);
  hyp(i,:)=data{i, 1}.hypno(7501+50:52500);
end
% HC=cell2mat(mice_sleep(:,1));   
% preS=cell2mat(mice_sleep(:,2));
% postS=cell2mat(mice_sleep(:,3));
% A=cell2mat(mice_sleep(:,8));
% C=cell2mat(mice_sleep(:,9));