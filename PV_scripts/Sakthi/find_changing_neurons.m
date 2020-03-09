function find_changing_neurons(obj);
%  find_changing_neurons(test);
sf=10;
data=moving_mean(obj,sf,1,1,0);

preon=10;
on=10;
poston=10;

[offw,onw]=separate_on_off(data,preon,on,poston);
[A,B,h,P]=sparse_boostrap(offw,onw,1,0,0,0);
figure
PSTH=PSTH_C_PV([A(:,1:size(A,2)/2),B,A(:,size(A,2)/2:size(A,2))]);

dummy=1;


