function scale_to_noise(neuron)

t=[1:200:size(neuron.C_raw,2),size(neuron.C_raw,2)];
for i=2:size(t,2)
    temp=neuron.C_raw(:,t(i-1):t(i))-neuron.C(:,t(i-1):t(i));
    temp=temp-medfilt1(temp,5,[],2);
    ns=GetSn(temp);
    neuron.C_raw(:,t(i-1):t(i))= neuron.C_raw(:,t(i-1):t(i))./ns;
end


