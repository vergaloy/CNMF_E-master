function [Train,Train_per,Train_per_inside,Train_shift,Train_rand_inside,Train_rand]=prepare_train_Data(C,balance,include)
% [Train,Train_per,Train_per_inside,Train_shift,Train_rand_inside,Train_rand]=prepare_train_Data(D,1);

if ~exist('include','var')
    include=1:size(C,2);
end

neuron=[];
neuron_shift=[];
neuron_rand_inside=[];
neuron_per_inside=[];
context=[];
s = char(97:122);
%% balance data with SMOTE
if (balance==1)
C=balance_data(C);
end

%%

for i=1:size(C,2)
    if (ismember(i,include))
        temp=C{1,i}./max(C{1,i},[],2);
        temp(isnan(temp))=0;
        neuron=[neuron;temp'];
        neuron_shift=[neuron_shift;circshift_columns(C{1,i}')];
        nrand=C{1,i}';
        neuron_rand_inside=[neuron_rand_inside;reshape(datasample(nrand(:),numel(nrand),'Replace',false),size(C{1,i}',1),size(C{1,i}',2))];
        neuron_per_inside=[neuron_per_inside;temp(randsample(size(temp,1),size(temp,1)),:)'];
        temp=cell(size(C{1,i},2),1);
        temp(:)={s(i)};
        context=[context;temp];
    end
end


n=size(neuron,1);
neuron_per=neuron(randsample(n,n),:);
neuron_rand=reshape(datasample(neuron(:),numel(neuron),'Replace',false),n,size(neuron,2));

Train = table(neuron,context,'VariableNames',{'neuron','context'});
Train_per = table(neuron_per,context,'VariableNames',{'neuron','context'});
Train_shift = table(neuron_shift,context,'VariableNames',{'neuron','context'});
Train_per_inside = table(neuron_per_inside,context,'VariableNames',{'neuron','context'});
Train_rand_inside = table( neuron_rand_inside,context,'VariableNames',{'neuron','context'});
Train_rand = table(neuron_rand,context,'VariableNames',{'neuron','context'});


function out=balance_data(in)
n=size(in,2);
labels=[];
for i=1:size(in,2)
    labels=[labels;ones(size(in{1, i},2),1)*i];
end
in=cat(2,in{:});
[temp,L] = SMOTE(in', [], 'Class', labels);
temp=temp./max(temp,[],1);
temp(isnan(temp))=0;
for i=1:n
    out{i}=temp(L==i,:)';
end


