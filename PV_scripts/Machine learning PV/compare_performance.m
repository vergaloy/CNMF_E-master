function compare_performance(T,R)
% compare_performance(out{1, 5},out{1, 1});
% compare_performance(out{1, 1},out{1, 2});
%% Groups:

% 1)  test data
% 2)  permutation control, destroy differences between behaviourla states, keep correlations. 
% 3)  Completly random 
% 4)  Shuffle points inside a condition, destroy correlation and mean differneces between neurons.  
% 5)  Shift rows, destroy correlation but preserve mean differneces between neurons. 

%%
C=T-R;
C=mean(C,3);
C=C+C';
values = {'HC','HC2','BS','BS2','AS','R','H','L','L2','N','N2','A','A2','C','C2'};

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
