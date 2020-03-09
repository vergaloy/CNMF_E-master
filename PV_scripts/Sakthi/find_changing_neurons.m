function find_changing_neurons(obj);

sf=10;
data=moving_mean(obj,sf,1,1,0);

preon=10;
on=10;
poston=10;

[offw,onw]=separate_on_off(data,preon,on,poston);
[A,B,h,P]=sparse_boostrap(onw,offw,0,1);


