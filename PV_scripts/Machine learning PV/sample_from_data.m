function out=sample_from_data(data,rep,m)
if (isempty(m))
    m=0;
end
n=ceil(rep/(m+1));
s=datasample(1:size(data,2)-2*m,n);
per=[];
for i=1:size(s,2)
    per=cat(2,per,[s(i):s(i)+m]);
end
per=per(1:rep);
out=data(:,per);    
end