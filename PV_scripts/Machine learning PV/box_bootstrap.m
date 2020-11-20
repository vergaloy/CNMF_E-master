function P=box_bootstrap(data,win)
% box_bootstrap(data,win)
parfor s=1:1000
    per(:,s)=mean(get_sample(data,win),2);   
end

P=mean(per==0,2);

end


function t=get_sample(data,win)
x=round(linspace(1,size(data,2),round(size(data,2)/win)));
n=size(x,2)-1;
s=zeros(size(data,1),1);
for i=1:n
    r=randperm(n,1);
    s=s+single(mean(data(:,x(r):x(r+1)),2)>0);
end
t=s>0;
end