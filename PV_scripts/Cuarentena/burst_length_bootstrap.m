function [POW]=burst_length_bootstrap(A,rep)

% [Burst_length,Power,Power_norm]=burst_length_bootstrap(HC,1000);
pow(1:rep)=0;

parfor i=1:rep
    I=randsample(size(A,1),size(A,1),true);
    Bootstrap_sample=A(I,:);
   [~,pow(i)]=burst_length(Bootstrap_sample,5);
end


POW=[mean(pow),prctile(pow,95),prctile(pow,5)]
