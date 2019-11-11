function sleep_stats(hypno,sf)
duration=length(hypno)/sf;
hypno=[-8;hypno];
rem=hypno;
rem(rem~=1)=0;
wake=hypno;
wake(wake~=0)=-1;
wake=wake+1;
nrem=hypno;
nrem(nrem~=0.5)=-0.5;
nrem=nrem+0.5;
rw=hypno;
rw(rw~=0.25)=-0.75;
rw=rw+0.75;
[pks,~] = findpeaks(wake);
wake_episodes=length(pks);
[pks,~] = findpeaks(rw);
rw_episodes=length(pks);
[pks,~] = findpeaks(rem);
rem_episodes=length(pks);
[pks,~] = findpeaks(nrem);
nrem_episodes=length(pks);
display('total time, average episode duration, episodes/hour. wake-highTheta-REM-NREM')

[sum(wake)/sf,sum(rw)/sf,sum(rem)/sf,sum(nrem)/sf;sum(wake)/sf/wake_episodes,sum(rw)/sf/rw_episodes,sum(rem)/sf/rem_episodes,sum(nrem)/sf/nrem_episodes;...
    wake_episodes/(duration/3600),rw_episodes/(duration/3600),rem_episodes/(duration/3600),nrem_episodes/(duration/3600)]



