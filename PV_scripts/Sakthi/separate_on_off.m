function [onw,offw]=separate_on_off(obj,preon,on,poston);

t=[zeros(1,preon),ones(1,on),zeros(1,poston)];
n=size(obj,2)/size(t,2);
t=repmat(t,1,n);

onw=obj(:,t==1);
offw=obj(:,t==0);


