function pattern_distances(ix,data,active);
% pattern_distances(pix,data,active);
a=0;
k=0;
for i=1:size(data,1)
coor=data{i, 1}.neuron.Coor; 
active_temp=active(a+1:a+size(coor,1));
a=a+size(coor,1);
coor=coor(active_temp);
ix_t=ix(k+1:k+size(coor,1));
plot_coor(coor,ix_t)
k=k+size(coor,1);


end

end


function out=coor2centroid(coor);

for i=1:size(coor,1)
   out(i,:)=mean(coor{i, 1},2);   
end

end

function plot_coor(coor,ixt)

figure;hold on;
for i=1:size(coor,1)
    c=coor{i};
    if (ixt(i)==0)
        fill(c(1,:),c(2,:),'black')
    elseif (ixt(i)==1)
        fill(c(1,:),c(2,:),'blue')
    else
        fill(c(1,:),c(2,:),'red')
    end
end

end

