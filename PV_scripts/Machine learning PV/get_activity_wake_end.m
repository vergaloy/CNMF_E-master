function A=get_activity_wake_end(data,sf,bin)

[out,hypno,N]=get_concantenated_data(data,sf,bin);
A=[];
for i=1:max(N);
    temp=out(N==i,:);
    h=hypno(i,:);
    temp=temp(:,h>=0.5);
    temp=temp(:,end-300+1:end);
    a=mean(temp,2);
    A=[A;a];
end