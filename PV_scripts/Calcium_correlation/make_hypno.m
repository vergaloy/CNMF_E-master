function hypno=make_hypno(hyp,neu,sf,t0,t1)
%    hypno=make_hypno(t,neuron.S,5.005287239,7501,52500);
hypno(1:size(neu,2))=0;

for i=1:size(hyp,1)-1
    if (strcmp('W',hyp{i,2}))
        hypno(round(hyp{i,1}*sf)+1+t0:round(hyp{i+1,1}*sf)+t0)=0;
    end
    if (strcmp('RW',hyp{i,2}))
        hypno(round(hyp{i,1}*sf)+1+t0:round(hyp{i+1,1}*sf)+t0)=0.25;
    end
    if (strcmp('S',hyp{i,2}))
        hypno(round(hyp{i,1}*sf)+1+t0:round(hyp{i+1,1}*sf)+t0)=0.5;
    end
    if (strcmp('R',hyp{i,2}))
        hypno(round(hyp{i,1}*sf)+1+t0:round(hyp{i+1,1}*sf)+t0)=1;
    end
end

if (strcmp('W',hyp{i,2}))
    hypno(round(hyp{i,1}*sf)+1:t1)=0;
end
if (strcmp('RW',hyp{i,2}))
    hypno(round(hyp{i,1}*sf)+1:t1)=0.25;
end
if (strcmp('S',hyp{i,2}))
    hypno(round(hyp{i,1}*sf)+1:t1)=0.5;
end
if (strcmp('R',hyp{i,2}))
    hypno(round(hyp{i,1}*sf)+1:t1)=1;
end






