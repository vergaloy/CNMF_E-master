function hypno=make_hypno(hyp,neu,sf,t0,ts)  %ts is the time shift between eeg and ca imaging
%    hypno=make_hypno(hyp,neuron.S,5.005679513,7501,0);


%% remember to run neuron=justdeconv(neuron,'thresholded','ar2');
hypno(1:size(neu,2))=0;

for i=1:size(hyp,1)   
    if (strcmp('W',hyp{i,2}))
        hyp{i,2}=0;
    end
    if (strcmp('RW',hyp{i,2}))
        hyp{i,2}=0.25;
    end
    if (strcmp('S',hyp{i,2}))
        hyp{i,2}=0.5;
    end
    if (strcmp('R',hyp{i,2}))
        hyp{i,2}=1;
    end
end

hyp = [hyp{:}];
hyp = reshape(hyp,[length(hyp)/2,2]);

hyp(:,1)=hyp(:,1)-ts;
k=find(hyp(:,1)>0,1)-1;

if(k>0)
    if (k>1)
        hyp(1:k-1,:)=[];
    end
    hyp(1,1)=0;
end


for i=1:size(hyp,1)-1
    if (hyp(i,2)==0)
        hypno(round(hyp(i,1)*sf)+t0:round(hyp(i+1,1)*sf)+t0)=0;
    end
    if (hyp(i,2)==0.25)
        hypno(round(hyp(i,1)*sf)+t0:round(hyp(i+1,1)*sf)+t0)=0.25;
    end
    if (hyp(i,2)==0.5)
        hypno(round(hyp(i,1)*sf)+t0:round(hyp(i+1,1)*sf)+t0)=0.5;
    end
    if (hyp(i,2)==1)
        hypno(round(hyp(i,1)*sf)+t0:round(hyp(i+1,1)*sf)+t0)=1;
    end
end






