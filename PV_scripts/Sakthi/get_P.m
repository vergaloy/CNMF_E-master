function P=get_P(num,dist)

if (isnan(num))
P=1;    
return
end

dist=sort(dist);
sim=length(dist);

if (num<min(dist))
    P=1;
end
if (num>max(dist))
    P=1/(sim+1);
else
    P=(sim-find(dist>=num,1)+1)/(sim+1);
end


