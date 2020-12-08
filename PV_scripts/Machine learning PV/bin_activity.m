function A=bin_activity(mice_sleep,session,b);
% bin_activity(mice_sleep,7,ix);

M=mice_sleep(:,session);
A=[];
for i=1:size(M,1)
    
    temp=M{i,1};
    a=temp(:);
    a(a==0)=[];
    th=prctile(a,95);
    temp=temp/th;
    temp(temp>1)=1;
    
    
    x=linspace(1,size(temp,2),b);
    ac=[];
    for j=1:size(x,2)-1
        ac(:,j)=mean(temp(:,x(j):x(j+1)),2);
    end
   A=catpad(1,A,ac);
end
    