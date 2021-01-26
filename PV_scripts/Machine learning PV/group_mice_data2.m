function  [mice_sleep,hyp,N]=group_mice_data2(data)
%  [mice_sleep,hyp]=group_mice_data(data);
N=[];
for i=1:size(data,1)
  temp=full(data{i, 1}.neuron.S);
  N=[N;ones(size(temp,1),1)*i];
%   m=temp(temp>0);
%   temp=temp/(mad(m,1)*3+median(m));
%   temp(temp>1)=1;
  mice_sleep(i,:)=Separate_by_behaviour_no_bin2(temp,50);
  hyp(i,:)=data{i, 1}.hypno(7501+50:52500);
end

