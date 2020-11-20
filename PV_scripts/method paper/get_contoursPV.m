function [circularity,pnr,cn,Areaest] = get_contoursPV(A,d1,d2,PNR,CN)
% [circularity,pnr,cn,Areaest] = get_contoursPV(neuron1.A,size(neuron1.Cn,1),size(neuron1.Cn,2),neuron1.PNR,neuron1.Cn)
% [circularity2,pnr2,cn2,Areaest2] = get_contoursPV(neuron2.A,size(neuron2.Cn,1),size(neuron2.Cn,2),neuron2.PNR,neuron2.Cn)
num_neuron = size(A,2);
thr=0.6;
for m=1:num_neuron    
    A_temp = A(:,m);
    [temp,ind] = sort(A_temp(:).^2,'ascend');
    temp =  cumsum(temp);
    ff = find(temp > (1-thr)*temp(end),1,'first');
    thr_a = A_temp(ind(ff));
    A_temp=full(reshape(A_temp,[d1 d2]));
    mask = bwlabel(medfilt2(A_temp>full(thr_a)));
    pnr(m,1)=mean(PNR(logical(mask))); 
    cn(m,1)=mean(CN(logical(mask))); 
    try
    [circularity(m,1),Areaest(m,1)]=get_circularity(mask);    
    catch
    circularity(m)=0;
    Areaest(m)=nan;
    end
     
end
end


function [circularity,Areaest]=get_circularity(mask)
Areaest = sum(mask(:));
perimpix = abs(conv2(mask,[1 -1],'same')) | abs(conv2(mask,[1;-1],'same'));
[Ip,Jp] = find(perimpix);
edgelist = convhull(Ip,Jp);
polyperim = sum(sqrt(diff(Ip(edgelist)).^2 + diff(Jp(edgelist)).^2));
circularity=4*pi*Areaest/polyperim^2;
end
