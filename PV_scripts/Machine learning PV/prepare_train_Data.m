function [Train,Train_per,Train_rand,Train_rand_inside,Train_shift]=prepare_train_Data(C,include)
% [Train,Train_per,Train_shift,Train_rand,Train_rand_inside]=prepare_train_Data(D,[1,2]);

if nargin<2
    include=1:size(C,2);
end

neuron=[];
neuron_shift=[];
neuron_rand_inside=[];
context=[];
s = char(97:122);
for i=1:size(C,2)
    if (ismember(i,include))
        neuron=[neuron;C{1,i}'];
        neuron_shift=[neuron_shift;circshift_columns(C{1,i}')];
        nrand=C{1,i}';
        neuron_rand_inside=[neuron_rand_inside;reshape(datasample(nrand(:),numel(nrand),'Replace',false),size(C{1,i}',1),size(C{1,i}',2))];
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
Train_rand = table(neuron_rand,context,'VariableNames',{'neuron','context'});
Train_rand_inside = table( neuron_rand_inside,context,'VariableNames',{'neuron','context'});
Train_shift = table(neuron_shift,context,'VariableNames',{'neuron','context'});