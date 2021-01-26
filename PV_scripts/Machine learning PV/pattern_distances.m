function pattern_distances(ix,data,active);
% pattern_distances(pix,data,active);
a=0;
k=0;
S1=[];
S2=[];
D1=[];
D2=[];

for i=1:size(data,1)
coor=data{i, 1}.neuron.Coor; 
active_temp=active(a+1:a+size(coor,1));
a=a+size(coor,1);
coor=coor(active_temp);
ix_t=ix(k+1:k+size(coor,1));

[s1,s2]=mean_distance_chance(coor,ix_t);

d1=get_closted_neightbor_dist(coor2centroid(coor(ix_t==1)));
d2=get_closted_neightbor_dist(coor2centroid(coor(ix_t==2)));
% d1=pdist(coor2centroid(coor(ix_t==1)));
% d2=pdist(coor2centroid(coor(ix_t==2)));

S1=[S1;s1];
S2=[S2;s2];
D1=[D1;d1'];
D2=[D2;d2'];

plot_coor(coor,ix_t,1)
k=k+size(coor,1);


end
D1=mean(D1,1);
D2=mean(D2,1);
S1=mean(S1,1);
S2=mean(S2,1);
figure;plot([1;2],[D2;D1],'kX');hold on;
violin([S2',S1'],'xlabel',{'Pre-consolidation','Post-consolidation'});

D1<prctile(S1,5)
D2<prctile(S2,5)




end


function d=get_closted_neightbor_dist(X);
if (~isempty(X))

for i=1:size(X,1)
    Xt=X;
    Xt(i)=[];
    [~,t] = knnsearch(Xt',X(i),'k',2);
    d(i)=mean(t);
end
else
    d=[];
end

end
function [S1,S2]=mean_distance_chance(coor,ix_t);
n1=sum(ix_t==1);
n2=sum(ix_t==2);
S1=[];
S2=[];
for s=1:1000
    if (n1>0)
    st=coor(randsample(size(coor,1),n1));
    S1(:,s)=get_closted_neightbor_dist(coor2centroid(st));
    end
    if (n2>0)
    st=coor(randsample(size(coor,1),n2));
    S2(:,s)=get_closted_neightbor_dist(coor2centroid(st));
    end
end
end



function out=coor2centroid(coor)
if (~isempty(coor))
for i=1:size(coor,1)
   out(i,:)=mean(coor{i, 1},2);   
end
else
    out=[];
end

end

function plot_coor(coor,ixt,newf)
if (newf==1)
figure;hold on;   
else
hold on;
end
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

