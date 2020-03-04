function [H]=get_H(X,W,minac)

t=size(W,2);

for i=1:t
    temp=X(logical(W(:,i)>0),:);
    temp(temp>0)=1;
    test=sum(temp,1);
    temp=temp;
   try
    temp=circshift_columns(temp', ceil(rand(1,size(temp,1)).*size(temp,2)-size(temp,2)/2))';
   catch
       dummy=1;
   end
    control=sum(temp,1);
    test(test<=prctile(control,99))=0;
    test(test<minac)=0;
    test(test>0)=1;
    H(i,:)=test;
end