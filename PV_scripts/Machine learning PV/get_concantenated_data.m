function [out,hypno,N]=get_concantenated_data(data,sf,bin)
out=[];
hypno=[];
N=[];
for i=1:size(data,1)   
    temp=full(data{i, 1}.neuron.S);
    n=ones(size(temp,1),1)*i;
    hyp=data{i, 1}.hypno;     
    temp=temp(:,7501:52500);
    hyp=hyp(7501:52500);   
    temp=bin_data(temp,sf,bin); 
    hyp=bin_data(hyp,sf,bin);        
    out=cat(1,out,temp);
    hypno=cat(1,hypno,hyp);
    N=cat(1,N,n);
end
end