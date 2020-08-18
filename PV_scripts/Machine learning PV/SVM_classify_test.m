function [iTest,iShift,iRan]=SVM_classify_test(mice_sleep)


D=divide_date_for_SVM(mice_sleep(:,1:3),'random_shifts',[1,2,3,4,5,6,7,8,9],'w_size',0,'kill_zero',1);
[Train,~,shift,Inside,~]=prepare_train_Data(D,1);
S=divide_date_for_SVM(mice_sleep(:,4:9),'w_size',0,'random_shifts',[1,2,3,4,5,6,7,8,9],'kill_zero',1);
[tTest,~,~,~,~]=prepare_train_Data(S,0);
[tTrain, ~] = trainClassifierPV_multiclass(Train,1);
[tInside, ~] = trainClassifierPV_multiclass(Inside,1);

[B,S,R]=table_array(tTest);

iTest=predict_SVM(B,tTrain.ClassificationSVM)-predict_SVM(B,tInside.ClassificationSVM);
iShift=predict_SVM(S,tTrain.ClassificationSVM)-predict_SVM(B,tInside.ClassificationSVM);
iRan=predict_SVM(R,tTrain.ClassificationSVM)-predict_SVM(B,tInside.ClassificationSVM);
end


function s=random_data(X)
z2=size(X,2);
sim=1000;
temp=X(:)';
n=numel(temp);
stop=0;
s=[];
while (stop==0)
r1=randi(n);    
r2=r1+randi(z2);
if(r2>n); r2=n;end
s=[s,temp(r1:r2)];
if (numel(s)>sim*z2);stop=1;end
end
s=s(1:sim*z2);
s=reshape(s,z2,sim)';
end


function [A,S,R]=table_array(T)
vari=unique(table2array(T(:,2)));
A=cell(1,length(vari));
S=cell(1,length(vari));
R=cell(1,length(vari));
for i=1:length(vari)
    temp=table2array(T(strcmp(vari{i, 1},table2array(T(:,2))),1));
    A{i}=temp;
    S{i}=circshift_columns(temp);
    R{i}=random_data(temp);
end
end

function Post=predict_SVM(B,model)
classes=model.ClassNames;
n=size(classes,1);
Post=zeros(n,size(B,2));

for i=1:size(B,2)
    temp = predict(model,B{i});
    temp=countcats(categorical(temp));
    temp=temp/sum(temp)*100;
    if (size(temp)<n)
        temp=[temp;0];
    end
    Post(:,i)=temp;
end
end



