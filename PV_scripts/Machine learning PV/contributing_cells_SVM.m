function [K]=contributing_cells_SVM(mice_sleep)
% [I,aC,P,predict_array,out_all]=contributing_cells_SVM(mice_sleep)
%  [I,aC,P,predict_array,out_all]=contributing_cells_SVM(mice_sleep);

sf=5;
binz=2;

sim=1000;
X=mice_sleep(:,2:3);
[X,j]=remove_inactive_cells(X,sf,binz);
 X=merge_cell_columns(X);
% data2predict=mice_sleep(:,[1,4:9]);
% [data2predict,~]=remove_inactive_cells(data2predict,sf,binz,j);
%% Get neurons with relevant weights.
ppm = ParforProgressbar(sim,'showWorkerProgress', true);
parfor i=1:sim
D=divide_date_for_SVM(X,'random_shifts',[1,2,3,4,5,6,7,8,9],'w_size',0,'kill_zero',1);
[tTrain,~,tPI,tS,tI,tR]=prepare_train_Data(D,1);
[~, aT(i),wT(:,i)] = trainClassifierPV(tTrain,0);
[~, aPI(i),wPI(:,i)] = trainClassifierPV(tPI,0);
[~, aS(i),wS(:,i)] = trainClassifierPV(tS,0);
[~, aI(i),wI(:,i)] = trainClassifierPV(tI,0);
[~, aR(i),wR(:,i)] = trainClassifierPV(tR,0);
ppm.increment();
end

delete(ppm); 
t=prctile(wT,2.5,2).*prctile(wT,97.5,2);
I=t>0;
m=mean(wT,2);
m=m(I);
m(m>0)=1;
m(m<0)=-1;
j(j)=I;
K=zeros(size(j,1),1);
K(j)=m;


% out_all=cell(2,5);
%  ppm2 = ParforProgressbar(sim,'showWorkerProgress', true);
% predict_array=cell(1,3);
% parfor i=1:sim
%     %% Extract relevant neurons
%     D=divide_date_for_SVM(X,'max_win',100,'random_shifts',[1,2,3,4,5,6,7,8,9],'w_size',0,'kill_zero',1);
%     [C,Cn]=separate_cells(I,D);
%     %% train SVM with relevant data
%     [tTrain,~,~,~,~]=prepare_train_Data(C,1,[1,2]);
%     [model, aC(i),~] = trainClassifierPV(tTrain,0);
%     %% predict test data
%     S=divide_date_for_SVM(data2predict,'w_size',0,'random_shifts',[1,2,3,4,5,6,7,8,9],'kill_zero',1);
%     [S,~]=separate_cells(I,S);
%     [tTest,~,~,~,~]=prepare_train_Data(S,0);
%     [T,S,R]=table_array(tTest);
%     predictT=predict_SVM(T,model.ClassificationSVM);
%     predictS=predict_SVM(S,model.ClassificationSVM);
%     predictR=predict_SVM(R,model.ClassificationSVM);
%     predict_array=arrange_cell(predict_array,{predictT,predictS,predictR});
%     %% get correlation between df and weights
%     df=mean(C{1, 2},2)-  mean(C{1, 1},2);
%     [~,P(i)]=corr(m,df,'Type','Spearman');
%     %% comparison of all conditions
%     D=remove_inactive_cells(divide_date_for_SVM(mice_sleep,'max_win',100,'random_shifts',[1,2,3,4,5,6,7,8,9],'w_size',0,'kill_zero',1),sf,binz,j);
%     [cD,~]=separate_cells(I,D);
%     temp=SVM_ABNs_matrix(cD);
%     out_all=arrange_matrix(out_all,temp);
%     ppm2.increment();
% end
% delete(ppm2); 
% out={aT,aPI,aS,aI,aR;wT,wPI,wS,wI,wR};
% save(strcat('SVM_contributing_cells_',datestr(now,'yymmddHHMMSS'),'.mat'))
end


function [C,nC]=separate_cells(I,D)
C=cell(1,size(D,2));
nC=cell(1,size(D,2));
for i=1:size(D,2)
    temp=D{1,i}(I,:);
    temp=temp(:,sum(temp,1)>0);
    C{1,i}=temp;
    temp=D{1,i}(~I,:);
    temp=temp(:,sum(temp,1)>0);
    nC{1,i}=temp;
end
end

function out=arrange_matrix(out,temp)

for i=1:size(out,2)
    out{1,i}=cat(3,out{1,i},temp{1,i});
    if (~isempty(out{2,i}))
    out{2,i}=out{2,i}+temp{2,i};
    else
      out{2,i}=temp{2,i};
    end
end

end


function out=arrange_cell(out,temp)
n=numel(temp);
for i=1:n
    out{i}=cat(3,out{i},temp{i});
end
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


function O=merge_cell_columns(X)

O={};
for i=1:size(X,1)
    O{i,1}=cat(2,X{i,1},X{i,2});
    O{i,2}=X{i,3};
end
end

function [out,I]=remove_inactive_cells(X,sf,binz,I);

if ~exist('I','var')
    I=[];
    skip=false;
else
    skip=true;
end

if (~skip)
    for i=1:size(X,2)
        temp=catpad(1,X{:,i});
        temp=bin_data(temp,5,2);
        a{i}=temp;
    end
    
    for s=1:1000
        for i=1:size(X,2)
            temp=datasample(a{1, i},size(a{1, i},2),2);
            temp(temp>0)=1;
            T(:,i,s)=mean(temp,2);
        end
    end
    T=prctile(T,5,3)>0;
    I=sum(T,2)>0;
end
k=1;
for i=1:size(X,1)
    n=size(X{i, 1},1);
    tI=I(k:k+n-1);
    tT=T(k:k+n-1,:);
    k=k+n;
    for j=1:size(X,2)
        temp=X{i,j};
        temp=temp.*tT(:,j);
        temp=temp(tI,:);
        out{i,j}=temp;
    end
end
end




