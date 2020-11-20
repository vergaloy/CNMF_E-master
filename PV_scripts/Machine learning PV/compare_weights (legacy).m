function compare_weights(mice_sleep)
sf=5;
binz=2;
%% get encoding data
encoding=mice_sleep(:,1:3);
[Ae,We]=train_data_svm(encoding,sf,binz);
%% get encoding data
consolidation=mice_sleep(:,4:7);
[Ac,Wc]=train_data_svm(consolidation,sf,binz);
%% get retrieval data
retrieval=mice_sleep(:,8:9);
[Ar,Wr]=train_data_svm(retrieval,sf,binz);
W=[We,Wc,Wr];
A=[Ae,Ac,Ar];
values = {'HC','preS','postS','REM','HT','LT','N','A','C'};
 

end


function [out,I]=remove_inactive_cells(X,sf,binz,I)
if ~exist('I','var')
    I=[];
    skip=false;
else
    skip=true;
end

if (~skip)
    for i=1:size(X,2)
        temp=catpad(1,X{:,i});
        temp=bin_data(temp,sf,binz);
        a{i}=temp;
    end
    
    for s=1:1000
        for i=1:size(X,2)
            T(:,i,s)=mean(datasample(a{1, i},size(a{1, 2},2),2),2);
        end
    end
    I=sum(prctile(T,5,3)>0,2)>0;
end
k=1;
for i=1:size(X,1)
    n=size(X{i, 1},1);
    tI=I(k:k+n-1);
    k=k+n;
    for j=1:size(X,2)
        out{i,j}=X{i,j}(tI,:);
    end
end
end


function O=merge_cell_columns(X,ind)
O={};

for i=1:size(X,1)
    n=1:size(X,2);
    n=~ismember(n,ind);
    O{i,1}=cat(2,X{i,~n});
    O{i,2}=cat(2,X{i,n});
end
end

function [A,W]=train_data_svm(data,sf,binz)

[X,j]=remove_inactive_cells(data,sf,binz);
X = X(~cellfun(@isempty, X(:,1)), :);

 W=zeros(size(j,1),size(data,2));
for i=1:size(X,2)
O=merge_cell_columns(X,i);
[tTrain,tPer,~,~,~,~]=prepare_train_Data(divide_date_for_SVM(O,'max_win',100,'random_shifts',1:size(O,2),'w_size',0,'kill_zero',1),1);
[~, tA1,tW] = trainClassifierPV(tTrain,0);
[~, tA2,~] = trainClassifierPV(tPer,0);
A(i)=tA1-tA2;
W(j,i)=tW;
end

end

