function [out,active]=kill_inactive_neurons_all(in,len,ref)

for i=1:size(in,1)
    temp=ones(size(in{i,1},1),1);  
    for j=1:size(ref,2)
        temp2=in{i,ref(j)};
        temp2(temp2>0)=1;
        temp2=1-mean(temp2,2);
        temp2=temp2.^len;
        temp2=temp2<0.05;
        temp=temp.*temp2;
    end
    active{i,1}=temp>0;
end

for i=1:size(in,1)
    for j=1:size(in,2)
        a=active{i};
        out{i,j}=in{i,j}(a,:);
    end
end
active=catpad(1,active{:});
end
