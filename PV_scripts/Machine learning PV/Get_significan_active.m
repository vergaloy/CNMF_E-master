function A=Get_significan_active(D);
% A=Get_significan_active(Da);
for i=1:size(D,2);
data=D{1,i};
len=290;
active=data;
active(active~=0)=1;
active=1-mean(active,2);
active=active.^len;
A(:,i)=active<0.05;
end