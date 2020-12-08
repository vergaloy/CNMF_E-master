function [active,mice_sleep]=get_inactive_cells(mice_sleep,D,sessions)
% active=get_inactive_cells(D,[1,2,3,8,9])
X=D(1,sessions);
X=catpad(2,X{:});

len=size(D{1, 8} ,2)*2;
[~,active]=remove_zeros(X,len);
k=0;
for i=1:size(mice_sleep,1)
    active_t=active(k+1:k+size(mice_sleep{i,1},1));
    k=k+size(mice_sleep{i,1},1);
    for j=1:size(mice_sleep,2)
        temp=mice_sleep{i,j};
        temp=temp(active_t,:);
        mice_sleep{i,j}=temp;
    end
end

end

function [data,active]=remove_zeros(data,len)
active=data;
active(active~=0)=1;
active=1-mean(active,2);
active=active.^len;
active=active<0.05;
data=data(active,:);
end