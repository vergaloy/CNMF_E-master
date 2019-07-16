function B=binndata(data,binsize,sf)  %binsize is in s, sf is sample frequency;
%n.CWB=binndata(n.CW,1,5.02)
warning off
d=binsize*sf;

for i=1:size(data,2)/d
    s=d*(i-1);
    B(:,i)=mean(data(1:size(data,1),s+1:s+d),2);
end
%B(B<0.1)=0;
%B=B./max(B,[],1);
s=sum(B,1);
t =std(s(~isnan(s)));
s=s<t*2;
B(:,s)=[];
B=B./max(B,[],1);
%B = B(:,all(~isnan(B))); 
end
