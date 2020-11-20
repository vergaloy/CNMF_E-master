function ac=get_active_neurons(mice_sleep)
len=1500;
for i=1:size(mice_sleep,2)
  [~,ac(:,i)]=kill_inactive_neurons(mice_sleep(:,i),len,1);  
end