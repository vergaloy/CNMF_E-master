function [D,F,P]=PVD_self(object)
sim=1000;
d1(1:sim)=0;
b2(1:sim,1:size(object,2))=0;
[~,a]=corrmatrix(object);
for i=1:sim
    rsample=reshape(object,[1,size(object,1)*size(object,2)]);
    rsample=randsample(rsample,size(rsample,2));
    rsample=reshape(rsample,[size(object,1),size(object,2)]);
    d1(i)=PVD(rsample,object,5);
    
    [~,b]=corrmatrix(rsample); 
    b2(i,:)=b;
           
end

D=mean(d1);
b2=sort(b2,1);
F=a-b2(sim*0.95,:);
F(F>=0)=1;
F(F<0)=0;
P=sum(F)/size(F,2);


