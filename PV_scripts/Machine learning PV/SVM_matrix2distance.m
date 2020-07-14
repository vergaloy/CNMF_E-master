function D=SVM_matrix2distance(T,R)
% D0=SVM_matrix2distance(out{1, 1},out{1, 2});
% D0=SVM_matrix2distance(out{1, 2}(:,:,1:500),out{1, 2}(:,:,501:1000));

values = {'HC1','HC2','PreS','PreS2','PostS','REM','HT','LT','NREM','A','A2','C','C2'};
C=T-R;

[B,~]=Bhattacharyya_coefficient_matrix(T,R);

M=mean(C,3); 
M=M+M';
plot_heatmap_PV(M,B,values,'Performance above chance','hot')


%% distribute array in column vectors
b=nchoosek(1:size(C,2),2);
v=zeros(size(C,3),size(b,1));
for i=1:size(b,1)
    c1=b(i,1);
    c2=b(i,2);
    v(:,i)=squeeze(C(c1,c2,:));
end

% get Distances matrix
D=vector2d(v);

%% Get threshold 

Zr=zeros(size(T,2)-1,1000);
for s=1:1000
    rsample=randomize(D);
    Z = linkage(rsample,'ward');
    Zr(:,s)=Z(:,3);
end
CI=prctile(Zr,5,2);
Z = linkage(D,'ward');
thr=find(Z(:,3)-CI>0,1);

if (thr~=1)
thr=median([Z(thr,3) Z(thr-1,3)]);
else
    thr=0;
end


%% Plot figures
% figure
% ax=heatmap(values,values,D);
% axp = struct(ax);       %you will get a warning
% axp.Axes.XAxisLocation = 'top';
figure
dendrogram(Z,'ColorThreshold',thr,'Labels', values)
yline(thr,'--')
ylabel('Linkage');




end


function d=vector2d(v)
r=roots([1 -1 -size(v,2)*2]);
r=r(r>0);
d=zeros(r);
b=nchoosek(1:r,2);
for i=1:size(v,2)
    c1=b(i,1);
    c2=b(i,2);
    m=mean(v(:,i));
    s=abs(0-m)/std(v(:,i));
    d(c1,c2)=s;
end
d=d+d';
d(isnan(d))=0;
end



function out=randomize(D)
out=zeros(size(D,1));

temp=D(logical(triu(ones(size(D,1)),1)));
temp=temp(randperm(length(temp)));
out(logical(triu(ones(size(D,1)),1)))=temp;
out=out+out';
end

function [B,DB]=Bhattacharyya_coefficient_matrix(A,B)
m1=mean(A,3);
m2=mean(B,3);
v1=var(A,[],3);
v2=var(B,[],3);
DB=0.25*log(0.25.*(v1./v2+v2./v1+2))+0.25*(((m1-m2).^2)./(v1+v2));
DB(isnan(DB))=0;
DB=DB+DB';
B=exp(-DB);
end

