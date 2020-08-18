function compare_performance(T,R)
% compare_performance(out_all{1, 1},out_all{1, 3});
% compare_performance(out{1, 3},out{1,1});
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
values = {'HC','preS','postS','R','HT','LT','NREM','A','C'};

[B,~]=Bhattacharyya_coefficient_matrix(T,R);
plot_heatmap_PV(C,B,values,'Change in accuracy','money')



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
