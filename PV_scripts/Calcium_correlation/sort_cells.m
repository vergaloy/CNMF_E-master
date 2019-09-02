function [Out_raw,I]=sort_cells(X,pattern,C_shift)
[~,I]=sort(sum(pattern,1),'descend');
order=pattern(:,I);
order(order==0)=nan;

for i=1:size(order,2)
ref_neuron=find(order(:,i)==1,2);
ref_shift=C_shift(ref_neuron(1),ref_neuron(2));
T=find(order(:,i)==1);
order(T,i)=C_shift(ref_neuron(1),T);
end
[~,I]=sort(min(order+(1:size(order,2))*999990,[],2));
Out_raw=X;
Out_raw=Out_raw(I,:);
order=order(I,:);
delete=min(order,[],2);
delete(~isnan(delete))=0;
delete(isnan(delete))=1;
Out_raw(logical(delete),:)=[];
order(logical(delete),:)=[];
end