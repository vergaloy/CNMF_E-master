
Cnt=neuron.Cn_all.*neuron.PNR_all; % neuron.Cn_all;

for i=1:4
Cn(:,:,i)=max(Cnt(:,:,6+(i-1)*8:13+(i-1)*8),[],3);
end
for i=2:size(Cn,3)
A=Cn(:,:,i);
B=Cn(:,:,i-1);
sim(i-1)=similarity_maximum_projection(A,B);
end
A=Cn(:,:,1);
B=Cn(:,:,4);
sim(i)=similarity_maximum_projection(A,B);


