function out=SVM_classify_test_2(mice_sleep)
out=[];
for i=1:size(mice_sleep,1)
pat=get_pattern_per_mice(mice_sleep(i,:));   
out=cat(3,out,pat);
end
end

function pat=get_pattern_per_mice(mice)
% Post=SVM_classify_test_2(mice_sleep(4,:));



D=divide_date_for_SVM(mice(:,1:3),'random_shifts',[],'w_size',0);
% D=divide_date_for_SVM(mice_sleep(:,1:3),'random_shifts',[1,2,3,4,5,6,7,8,9],'w_size',0,'kill_zero',1);
[Train,per,shift,inside,fullrand]=prepare_train_Data(D);
S=divide_date_for_SVM(mice(:,4:9),'w_size',0);
[Test,~,~,~,~]=prepare_train_Data(S);
[tTrain, Acc] = trainClassifierPV_multiclass(fullrand,1);

[B,R]=table_array(Test);
P=get_probability_tresholds(tTrain.ClassificationSVM,R);
Post=predict_SVM(B,P,tTrain.ClassificationSVM);

pat=get_significant_patterns(Post);

% imagesc([B{1, 1},Post{1, 1}(:,3)>0]');


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

function P=get_probability_tresholds(model,R)
P=zeros(size(R,2),size(model.ClassNames,1));
for i=1:size(R,2)
    [~,~,~,temp] = predict(model,R{i});
    for j=1:size(temp,2)    
    P(i,j)=prctile(unique(temp(:,j)),95,1); 
    end
end
end

function [A,R]=table_array(T)
vari=unique(table2array(T(:,2)));
A=cell(1,length(vari));
R=cell(1,length(vari));
for i=1:length(vari)
    temp=table2array(T(strcmp(vari{i, 1},table2array(T(:,2))),1));
    A{i}=temp;
    R{i}=random_data(temp);
end


end

function Post=predict_SVM(B,P,model)

n=size(P,1);
Post=cell(1,n);

for i=1:n
    [~,~,~,temp] = predict(model,B{i});
    Post{i}=temp-P(i,:);
end
end

function pat=get_significant_patterns(Post)

pat(size(Post{1, 1},2),size(Post,2))=0;

for i=1:size(Post,2)
pat(:,i)=sum(Post{1, i}>0,1) ; 
end

end



