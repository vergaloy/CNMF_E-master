function [onw,offw]=separate_on_off(obj,preon,on,poston);


before=[ones(1,preon),zeros(1,on),zeros(1,poston)];
n=size(obj,2)/size(before,2);
before=repmat(before,1,n);
before=obj(:,before==1);
%before=moving_mean(before,1,preon,preon,0);


during=[zeros(1,preon),ones(1,on),zeros(1,poston)];
during=repmat(during,1,n);
during=obj(:,during==1);
%during=moving_mean(during,1,preon,preon,0);

after=[zeros(1,preon),zeros(1,on),ones(1,poston)];
after=repmat(after,1,n);
after=obj(:,after==1);
%after=moving_mean(after,1,preon,preon,0);

onw=durin;
offw=[before,after];



