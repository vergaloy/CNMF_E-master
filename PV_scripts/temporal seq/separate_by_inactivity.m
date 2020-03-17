function [active,inactive]=separate_by_inactivity(num,obj,hyp)
% [active,inactive]=separate_by_inactivity(8,neuron.S,hypno);




[C]=Separate_by_behaviour(obj,hyp);


[W,~,~]=Get_seqNMF(C,setdiff(1:size(C,2),num),1);


ind=(sum(W,2))>0;

active=obj(ind,:);
inactive=obj(~ind,:);
