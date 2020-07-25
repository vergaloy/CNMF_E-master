function S=TestvsTrain(mice_sleep)


D=divide_date_for_SVM(mice_sleep,'random_shifts',[1,2,3,4,5,6,7,8,9]);
[Train,per,rand,inside,shift]=prepare_train_Data(D,[1,2,3]);
[Test,~,~,~,~]=prepare_train_Data(D,[4,5,6,7,8,9]);
[tTrain, ~] = trainClassifierPV_multiclass(Train,0);
[tper, ~] = trainClassifierPV_multiclass(per,0);
[tshift, ~] = trainClassifierPV_multiclass(shift,0);
[trand, ~] = trainClassifierPV_multiclass(rand,0);
[tinside, ~] = trainClassifierPV_multiclass(inside,0);


S={testSVM(tTrain,Test),testSVM(tper,Test),testSVM(trand,Test),testSVM(tinside,Test),testSVM(tshift,Test)};

end


function s=testSVM(train,test)
yfit = train.predictFcn(test);
w=size(yfit,1)/6;
s=zeros(3,6);
for i=1:6
    temp=yfit(i*w-w+1:i*w);
    idx = strfind(temp, 'a');idx = find(~(cellfun('isempty', idx)));a=length(idx)/w;
    idx = strfind(temp, 'b');idx = find(~(cellfun('isempty', idx)));b=length(idx)/w;
    idx = strfind(temp, 'c');idx = find(~(cellfun('isempty', idx)));c=length(idx)/w;
    s(1,i)=a;
    s(2,i)=b;
    s(3,i)=c;
end
end