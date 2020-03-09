function  PSTH_C_PV(obj,sf,bin,stimulus_onset,stimulus_duration,Trial_duration)
%eg. PSTH_C_PV(data);

if nargin<2
 sf=10;
  bin=1;
 stimulus_onset=10/bin;
 stimulus_duration=10/bin;
 Trial_duration=30/bin;
end

data=bin_data(obj,sf,bin);
b_range=size(data,2);
trials=floor((b_range)/(Trial_duration));
temp(1:size(data,1),1:floor((Trial_duration)))=0;
trail_data=0;
for t=1:trials
    start_x=floor((t-1)*(Trial_duration)+1);
    end_x=start_x+floor((Trial_duration)-1);
    temp=temp+data(1:size(data,1),start_x:end_x);
end
C=temp./trials;
A=[C(:,1:stimulus_onset),C(:,stimulus_onset+stimulus_duration+1:Trial_duration)];
B=C(:,stimulus_onset+1:stimulus_onset+stimulus_duration);

[A,B,h,P]=sparse_boostrap(A,B,0,0,0,1);
figure
C=[A(:,1:size(A,2)/2),B,A(:,size(A,2)/2+1:size(A,2))];
b=bar(1:Trial_duration,sum(C,1),'histc','EdgeColor','black','FaceColor','black');
set(b,'EdgeColor','k')
xlim([1 Trial_duration])

figure;bar(bin_data(sum(data,1),1,5),'histc','EdgeColor','black','FaceColor','black');
[R,P] = corr((1:size(sum(data,1),2))',sum(data,1)');

cprintf('*blue','Correlation and P-value of trials in time  R=%1.3g P=%1.3g\n',R,P)
if (P<0.05)
cprintf([1,0.5,0],'Trails are correlated in time!! resulst may not be accurate.\n')
end
cprintf('*blue','Neurons increasing their activity= %1.3g/%1.3g \n',find(h==0,1),size(h,2))
cprintf('*blue','Neurons decreasing their activity= %1.3g/%1.3g\n',(size(h,2)-find(h==0,1,'last')),size(h,2))








