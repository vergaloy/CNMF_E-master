function remove_bad_traces(neuron)

for i=1:size(neuron.C_raw,1)
    temp=neuron.C_raw(i,:);
    up=temp;
    up(up<rms(temp)*3)=0;
    up=findpeaks(up);
    
    down=temp;
    down(down>-rms(temp)*3)=0;
    down=abs(down);
    down=findpeaks(down);
    
    r(i)=length(down)/(length(down)+length(up));     
end

ind_del=(r>0.4);
  ind = 1:size(neuron.A, 2);
  neuron.delete(ind(ind_del));  
    