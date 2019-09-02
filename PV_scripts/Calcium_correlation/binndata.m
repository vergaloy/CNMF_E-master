function [B,total_activity,burst]=binndata(data,binsize,sf,sd,norm)  %binsize is in s, sf is sample frequency;
%n.CWB=binndata(n.CW,1,5.02)
warning off
d=binsize*sf;

B=data;
B(B<0.0001)=0;
if norm==1
    B=B./max(B,[],2);
end
B(isnan(B))=0;
s=B;
s(s==0)=nan;
s(s<nanstd(s,1,2)*2)=0;
s(s>0)=1;
s(isnan(s))=0;
s=sum(s,1);
total_activity =movmean(s,sf);
%total_activity=total_activity./max(total_activity,2);
%t =mean(total_activity(~isnan(total_activity)))+2*std(total_activity(~isnan(total_activity)));
s=total_activity<2;

i=1;
v=1;
if (sd==0)
    s=total_activity>0;
end
burst(1:size(data,2))=0;
while i<size(s,2)
    if (s(i)==0)
        start=i;
        while (s(i)==0)
            burst(i)=1;
            i=i+1;
            if (i>=size(s,2))
                break
            end
        end
        finish=i;
        D(:,v)=nanmean(B(:,start:finish),2);
        v=v+1;
    end
    burst(i)=0;
    i=i+1;
end
B=D;
D=[];
end

