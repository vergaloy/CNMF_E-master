function sim=evaluate_motion(neuron)
Cn=neuron.PNR_all.*neuron.Cn_all;
for i=2:size(Cn,3)
A=Cn(:,:,i);
B=Cn(:,:,i-1);
sim(i)=similarity_maximum_projection(A,B);
end


















% Cn=neuron.PNR_all.*neuron.Cn_all;
% 
% [d1,d2,T] = size(Cn);
% options_r = NoRMCorreSetParms('d1',d1,'d2',d2,'max_shift',20,'iter',1,'correct_bidir',false,'init_batch',1);
% for i=3:size(Cn,3)
% Y=Cn(:,:,i-2:i);
% [M,shifts1,~,~] =normcorre_test(Y,options_r);
% shifts_r = squeeze(cat(3,shifts1(:).shifts));
% shifts(i-1,:) = sum(shifts_r,1);
% end

