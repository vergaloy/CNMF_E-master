function hypno=make_hypno(hyp,neu,sf)

for i=1:size(hyp,1)-1   
    if (strcmp('W',hyp{i,2}))
        hypno(round(hyp{i,1}*sf)+1:round(hyp{i+1,1}*sf))=0;
    end  
    if (strcmp('RW',hyp{i,2}))
        hypno(round(hyp{i,1}*sf)+1:round(hyp{i+1,1}*sf))=0.25;
    end   
    if (strcmp('S',hyp{i,2}))
        hypno(round(hyp{i,1}*sf)+1:round(hyp{i+1,1}*sf))=0.5;
    end    
    if (strcmp('R',hyp{i,2}))
        hypno(round(hyp{i,1}*sf)+1:round(hyp{i+1,1}*sf))=1;
    end    
end 
i=i+1;

if (strcmp('W',hyp{i,2}))
    hypno(round(hyp{i,1}*sf)+1:size(neu,2))=0;
end
if (strcmp('RW',hyp{i,2}))
    hypno(round(hyp{i,1}*sf)+1:size(neu,2))=0.25;
end
if (strcmp('S',hyp{i,2}))
    hypno(round(hyp{i,1}*sf)+1:size(neu,2))=0.5;
end
if (strcmp('R',hyp{i,2}))
    hypno(round(hyp{i,1}*sf)+1:size(neu,2))=1;
end





