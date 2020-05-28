data=load_mice_data()
[mice_sleep,hyp]=group_mice_data(data);
 [D,a]=bin_mice_sleep(mice_sleep,[1,2,3,4,5,6,7,8,9],2);
E=extrac_sleep_episodes(mice_sleep,hyp,300);
CI=bootstrap(a);

HC=cell2mat(mice_sleep(:,1));
preS=cell2mat(mice_sleep(:,2));
postS=cell2mat(mice_sleep(:,3));
A=cell2mat(mice_sleep(:,8));
C=cell2mat(mice_sleep(:,9));



[~,~,~,m(:,1)]=burst_length(HC,5);
[~,~,~,m(:,2)]=burst_length(preS,5);
[~,~,~,m(:,3)]=burst_length(postS,5);
[~,~,~,m(:,4)]=burst_length(A,5);
[~,~,~,m(:,5)]=burst_length(C,5);


[m(:,1),p(:,1)]=burst_length(D{1,1},0.5);
[m(:,2),p(:,2)]=burst_length(D{1,2},0.5);
[m(:,3),p(:,3)]=burst_length(D{1,3},0.5);
[m(:,8),p(:,8)]=burst_length(D{1,8},0.5);
[m(:,9),p(:,9)]=burst_length(D{1,9},0.5);
[m(:,4:7),p(:,4:7)]=get_pwelch_sleep(E);

POW=burst_length_bootstrap(D{1,1},1000);
POW=burst_length_bootstrap(D{1,2},1000);
POW=burst_length_bootstrap(D{1,3},1000);
POW=burst_length_bootstrap(D{1,4},1000);
POW=burst_length_bootstrap(D{1,5},1000);