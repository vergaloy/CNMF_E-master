function [out1,out2]=separate_responding_cells(obj,in1,in2)
%[out1,out2]=separate_responding_cells(neuron.S,neuron.S(:,1:600*5.01),neuron.S(:,5.01*981:5.01*1580));
[P]=Block_boostrap(in1,in2,100,10000,1);

[ ind, ~] = FDR( P, 0.05, 0);
out1=obj(ind,:);
out2=obj;
out2(ind,:)=[];
out1=moving_mean(out1,5.01,2,1/5.01,0);
out2=moving_mean(out2,5.01,2,1/5.01,0);


phist=[moving_mean(in1,5.01,60,5,0),moving_mean(in2,5.01,60,5,0)];

phist1=phist(ind,:);
phist2=phist;
phist2(ind,:)=[];



