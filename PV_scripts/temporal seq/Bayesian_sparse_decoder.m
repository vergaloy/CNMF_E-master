function [EA,EB,PA,PB,PAs,PBs]=Bayesian_sparse_decoder(A,B,order,dims)

%   [EA,EB,PA,PB,PAs,PBs]=Bayesian_sparse_decoder(C{1,9}(:,1:150),C{1,9}(:,151:300),1,100);

[PA,PB]=Bayesian_inference(A,B,order,dims);
[PAs,PBs]=Bayesian_inference_same(A,B,order,dims);


correctA=(PA>prctile(PAs,95));
correctB=(PB>prctile(PBs,95));

EA=nanmean(correctA)
EB=nanmean(correctB)

controlA=(PAs>0.5);
controlB=(PBs>0.5);

EAcontrol=nanmean(controlA)
EBcontrol=nanmean(controlB)