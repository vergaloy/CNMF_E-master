function [burst_rate,spike_per_burst,burst_ratio]=get_burst_rate(temp,sf,bin,min_spike)


M=moving_mean(temp,sf,bin,1/sf,0);
thr=(min_spike-0.5)/(sf*bin); %0.5 is substracted to fix round up problems
M(M<=thr)=0;


burst_rate(1:size(M,1))=0;
spike_per_burst(1:size(M,1))=0;
burst_ratio(1:size(M,1))=0;

for i=1:size(M,1)
[pks,locs] = findpeaks(M(i,:));
burst_rate(i)=size(pks,2)/(size(temp,2)/sf);
spike_per_burst(i)=mean(round(pks*sf*bin));  %the average of the maximum spike per burst
t=temp(i,:);
burst_ratio(i)=sum(t(M(i,:)>=thr))/sum(t);
end

burst_rate=burst_rate';
spike_per_burst=spike_per_burst';
burst_ratio=burst_ratio';