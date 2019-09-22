function sleepdata=separate_by_sleep(ob,hypno)

sleepdata.wake=ob;
sleepdata.wake(:,hypno~=0)=[];
sleepdata.nrem=ob;
sleepdata.nrem(:,hypno~=0.5)=[];
sleepdata.rem=ob;
sleepdata.rem(:,hypno~=1)=[];
sleepdata.rw=ob;
sleepdata.rw(:,hypno~=0.25)=[];