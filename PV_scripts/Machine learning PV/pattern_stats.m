function [Out,Rep,Pat,Pid]=pattern_stats(Xall,Wall,Hall,W)
%   [Out,Rep,Pat,Pid]=pattern_stats(Xall,Wall,Hall);
pat_ac=[];
ac=[];
N=size(Xall,2);

%% get Ds

for i=1:N
    w=Wall{1,i};
    h=Hall{1,i};
    x=Xall{1,i};
    I=~logical((w>0)*h)&~isnan(x);
    temp=x;
    temp(I)=0;
    temp(isnan(temp))=[];
   pat_ac=catpad(2,pat_ac,temp(:)); 
   x(isnan(x))=[];
   ac=catpad(2,ac,x(:));
end
[ac_CI,ac_P]=bootstrap(ac,4);  %(N^2-N)/2
[pat_CI,pat_P]=bootstrap(pat_ac,4);
[patNorm_CI,patNorm_P]=bootstrap_dif(pat_ac,ac,(N^2-N)/4);
%%
[Rep,Pat,Pid]=find_repeated_patterns(W);


Out=table({ac_P;pat_P;patNorm_P},{ac_CI;pat_CI;patNorm_CI;},'RowNames',{'Cells activity','Pattern activity','% of pattern activity'},'VariableNames',{'P','CI'});


   