function remove_bad_traces2(neuron)

for i=1:size(neuron.C_raw,1)
    temp=neuron.C_raw(i,:);
    up=temp;
    up(up<rms(temp)*2)=0;
    up=findpeaks(up);
    
    down=temp;
    down(down>-rms(temp)*2)=0;
    down=abs(down);
    down=findpeaks(down);
    if (isempty(down))
        down=0;
    end
    
    r(i)=prctile(down,50)/prctile(up,50);     
end

ind_del=(r>1);
  ind = 1:size(neuron.A, 2);
  neuron.delete(ind(ind_del));  
    