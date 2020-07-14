function dif_hist(w1,w2)
% dif_hist(late,early);

for i=1:1000
    s1=datasample(w1,length(w1));
    s2=datasample(w2,length(w2));
    
    [s1,e] = histcounts(s1,0:0.05:5);
     s1=s1/sum(s1);
    s2 = histcounts(s2,0:0.05:5);
     s2=s2/sum(s2);
    
    dif(i,:)=s1-s2;
    
end


out(1,:)=mean(dif,1);
out(2,:)=prctile(dif,99.95,1)-mean(dif,1);
out(3,:)=mean(dif,1)-prctile(dif,0.05,1);
out(4,:)=e(2:end);
out(5,:)=0;

out=out';
dummy=1