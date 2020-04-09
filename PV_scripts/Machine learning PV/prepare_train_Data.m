function [Train,Train_per,Train_shift,Train_rand]=prepare_train_Data(C)
x1=C{1,1}';
x2=C{1,2}';
x3=C{1,3}';



neuron=[x1;x2;x3];
n=size(neuron,1);
neuron_per=neuron(randsample(n,n),:);
neuron_shift=[circshift_columns(x1);circshift_columns(x2);circshift_columns(x3)];
neuron_rand=reshape(datasample(neuron(:),numel(neuron),'Replace',false),n,size(neuron,2));


context   = cell(size(neuron,1),1);
a=size(x1,1);
context(1:a,1)={'HC'};
context(a+1:a+size(x2,1),1)={'preShock'};
a=a+size(x2,1);
context(a+1:a+size(x3,1),1)={'postShock'};

Train = table(neuron,context);
Train_per = table(neuron_per,context);
Train_shift = table(neuron_shift,context);
Train_rand = table(neuron_rand,context);