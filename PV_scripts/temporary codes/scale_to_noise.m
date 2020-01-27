function scale_to_noise(neuron,num)
% scale_to_noise(neuron,500);
a=round(size(neuron.C_raw,2)/num);
t=linspace(1,size(neuron.C_raw,2),a);
for i=2:size(t,2)
    temp=neuron.C_raw(:,t(i-1):t(i))-neuron.C(:,t(i-1):t(i));
    temp=temp-medfilt1(temp,5,[],2);
    ns=GetSn(temp);
    neuron.C_raw(:,t(i-1):t(i))= neuron.C_raw(:,t(i-1):t(i))./ns;
end


