function [out,a]=bin_mice_sleep(obj,s,bin)
%  [D,a]=bin_mice_sleep(mice_sleep,[4],2);
sf=5;
for i=1:length(s)
    temp=obj(:,s(i));
    temp=catpad(1,temp{:});
    out{1,i}=bin_data(temp,sf,bin); 
    a(:,i)=nanmean(out{1,i},2);
end

