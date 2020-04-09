function [active,inactive]=separate_by_inactivity(num,obj,hyp)
% [active,inactive]=separate_by_inactivity(3,neuron.S,hypno);




[C]=Separate_by_behaviour(obj,hyp,50);


[W,~,~]=Get_seqNMF(C,setdiff(1:size(C,2),num),8,1);


ind=(sum(W,2))>0;

active=obj(ind,:);
inactive=obj(~ind,:);

[Ca]=Separate_by_behaviour(active,hyp,50);
[Ci]=Separate_by_behaviour(inactive,hyp,50);

Aa=zeros(size(active,1),size(C,2));
for i=1:size(Ca,2)
    Aa(:,i)=mean(Ca{1,i},2);
end
Aa %% need to fix

Ai=zeros(size(inactive,1),size(C,2));
for i=1:size(Ci,2)
    Ai(:,i)=mean(Ci{1,i},2);
end
Ai
dummy=1;
