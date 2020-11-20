function compare_performance(T,R)
% compare_performance(SVM{1, 1},SVM{1, 4});
% compare_performance(DBNs{1, 1},DBNs{1, 3});
%% Groups:

% 1)  test data
% 2)  permutation control, destroy differences between behaviourla states, keep correlations. 
% 3)  Shift rows, destroy correlation but preserve mean differneces between neurons.
% 4)   Shuffle points inside a condition, destroy correlation and mean differneces between neurons.  
% 5)  Completly random 

%%
C=T-R;
C=mean(C,3);
if (C(1,2)~=C(2,1))
C=C+C';
end
values={'HC','preS','postS','REM','HT','LT','N','A','C'};  %,'R','HT','LT','NREM','A','C'

% [B,~]=Bhattacharyya_coefficient_matrix(T,R);
P=get_p_val_per(T,R);
plot_heatmap_PV(C,'P_vals',P,'x_labels',values,'y_labels',values,'tit','Change in accuracy','Colormap','money','FontSize',19)


% dendrogram(linkage(squareform(C,'tovector'),'complete'),0,'Labels',values);

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

function out=get_p_val_norm(T,R)
C=T-R;
out=zeros(size(C,1),size(C,2));
b=nchoosek(1:size(C,2),2);
for i=1:size(b,1)
    temp=squeeze(C(b(i,1),b(i,2),:));
    m=abs(0-mean(temp))./std(temp);
    out(b(i,1),b(i,2))=2*normcdf(-m);
end
out=out+out';
out=out+diag(ones(1,size(out,1)));
out=1-squareform(1-out,'tovector');
[~,~,~, out]=fdr_bh(out);
out=1-squareform(1-out);
end

function out=get_p_val_per(T,R)
C=T-R;
out=double((prctile(C,2.5,3)).*prctile(C,99.75,3)>0);  
out=out+out';
out(out==1)=0.03;
out(out==0)=1;
% .*prctile(C,99.75,3)
end





