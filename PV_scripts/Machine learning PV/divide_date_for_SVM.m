function D=divide_date_for_SVM(mice_sleep,D)  %this only work for DK REMid experimental desing
% D=divide_date_for_SVM(mice_sleep);
% D=divide_date_for_SVM(mice_sleep,D);
if nargin<2
    D=cell(1,13);
    no_skip=1;
else
    no_skip=0;
end

bin=2;
sf=5;

%%
%HC
if(logical(no_skip))
    temp=mice_sleep(:,1);
    temp=bin_data(catpad(1,temp{:}),sf,bin);
    D{1}=temp(:,1:round(size(temp,2)/2));
    D{2}=temp(:,round(size(temp,2)/2)+1:end);
    
    %%
    %preS
    temp=mice_sleep(:,2);
    temp=bin_data(catpad(1,temp{:}),sf,bin);
    D{3}=temp(:,1:round(size(temp,2)/2));
    D{4}=temp(:,round(size(temp,2)/2)+1:end);
    
    %%
    %postS
    temp=mice_sleep(:,3);
    temp=bin_data(catpad(1,temp{:}),sf,bin);
    D{5}=temp;
    %%
    %A
    %preS
    temp=mice_sleep(:,8);
    temp=bin_data(catpad(1,temp{:}),sf,bin);
    D{10}=temp(:,1:round(size(temp,2)/2));
    D{11}=temp(:,round(size(temp,2)/2)+1:end);
    %%
    %C
    temp=mice_sleep(:,9);
    temp=bin_data(catpad(1,temp{:}),sf,bin);
    D{12}=temp(:,1:round(size(temp,2)/2));
    D{13}=temp(:,round(size(temp,2)/2)+1:end);
end
%%
% REM
temp=mice_sleep(:,5);
temp=shift_sleep(temp);
temp=bin_data(catpad(1,temp{:}),sf,bin);
D{6}=temp(:,1:size(D{1, 5},2));
%%
% HT
temp=mice_sleep(:,6);
temp=shift_sleep(temp);
temp=bin_data(catpad(1,temp{:}),sf,bin);
D{7}=temp(:,1:size(D{1, 5},2));
%%
% LT
temp=mice_sleep(:,7);
temp=shift_sleep(temp);
temp=bin_data(catpad(1,temp{:}),sf,bin);
D{8}=temp(:,1:size(D{1, 5},2));
%%
% LT
temp=mice_sleep(:,8);
temp=shift_sleep(temp);
temp=bin_data(catpad(1,temp{:}),sf,bin);
D{9}=temp(:,1:size(D{1, 5},2));

function out=shift_sleep(in)
out=cell(size(in,1),1);
for i=1:size(in,1)
    t=circshift_columns((1:size(in{i,1},2))');
    temp=in{i,1};
    out{i,1}=temp(:,t);
end





