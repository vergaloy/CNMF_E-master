function  PSTH_C_PV(obj,sf,bin,stimulus_onset,stimulus_duration,trial_duration)
%eg. PSTH_C_PV(neuron.S);

if nargin<2
 sf=10;
 bin=1;
 stimulus_onset=10;
 stimulus_duration=10;
 trial_duration=30;
end

%%
 stimulus_onset=stimulus_onset/bin;
 stimulus_duration=stimulus_duration/bin;
 trial_duration=trial_duration/bin;
 
 if (stimulus_onset+stimulus_duration==trial_duration)
     divide_plot=0;
 else
     divide_plot=1;
 end
 data=bin_data(full(obj),sf,bin);
[d,r]=size(data);  % dimensions (neurons) and range (temoral length); 
trials=floor((r)/(trial_duration));
if (r-trials*trial_duration>0)
cprintf([1,0.5,0],'WARNING: Is not posible to divide the data in the amount of trails specified.\n')
cprintf([1,0.5,0],'Data was cutted to fit with the number of trails.\n')
data=data(:,1:trials*trial_duration);
end
temp(1:d,1:floor((trial_duration)))=0;
I=zeros(1,size(data,2));
for t=1:trials
    start_x=floor((t-1)*(trial_duration)+1);
    end_x=start_x+floor((trial_duration)-1);
    I(start_x+stimulus_onset:start_x+stimulus_onset+stimulus_duration-1)=1;
    temp=temp+data(1:size(data,1),start_x:end_x);
end
C=temp./trials;
A=[C(:,1:stimulus_onset),C(:,stimulus_onset+stimulus_duration+1:trial_duration)];
B=C(:,stimulus_onset+1:stimulus_onset+stimulus_duration);

[A,B,h,P]=sparse_boostrap(A,B,0,0,1,divide_plot);  %A,B,paired,use_median,correct_mc,divide_plot
figure
if (divide_plot)
D=[A(:,1:size(A,2)/2),B,A(:,size(A,2)/2+1:size(A,2))];
else
 D=[A,B];   
end
b=bar(1:size(D,2),sum(D,1),'histc','EdgeColor','black','FaceColor','black');
set(b,'EdgeColor','k')
xlim([1 trial_duration])

figure;bar(sum(data(:,I==0),1),'histc','EdgeColor','black','FaceColor','black');
hold on
bar(sum(data(:,I==1),1),'histc','EdgeColor','black','FaceColor','red');

[R,P] = corr((1:sum(I==0))',sum(data(:,I==0),1)');
cprintf('*blue','Correlation and P-value of A in time  R=%1.3g P=%1.3g\n',R,P)
[R,P2] = corr((1:sum(I==1))',sum(data(:,I==1),1)');
cprintf('*blue','Correlation and P-value of B in time  R=%1.3g P=%1.3g\n',R,P2)
if (P<0.05||P2<0.05)
cprintf([1,0.5,0],'Trails are correlated in time!! resulst may not be accurate ASK PABLO.\n')
end
cprintf('*blue','Neurons increasing their activity= %1.3g/%1.3g \n',find(h==0,1),size(h,2))
cprintf('*blue','Neurons decreasing their activity= %1.3g/%1.3g\n',(size(h,2)-find(h==0,1,'last')),size(h,2))
