function out=mean_activity_pattern_sorted(D,Rep,Pid,Pat,sessions)
% Pattern_separated=mean_activity_pattern_sorted(D,Rep,Pid,Pat,[4,5,6,7]);
out=cell(1,3);
[out{1,1},out{1,2},out{1,3}]=get_CI_P_value(D,Rep,Pid,Pat,sessions);
out = cell2table(out,...
    'VariableNames',{'CI' 'P-value' 'CI_ratio'});
end

function [Pat_CI,Pat_P,CId]=get_CI_P_value(D,Rep,Pid,Pat,Ses)

for s=1:size(Ses,2)
ac_pat=find(Rep(:,Ses(s))==1);
for i=1:length(ac_pat)
    temp=Pat(:,Pid==ac_pat(i))>0;
    temp=median(temp,2);
    ac(:,i)=temp;
end
%  ac=sum(ac,2)>0;
ac=sum(ac,2)>0;
AC(:,s)=ac;
end
AC=median(AC,2)>0;

Pattern_neu=[];
for i=1:size(D,2)
    temp=D{1, i};
    t_pat=temp(AC,:);
    t_no_pat=temp(~AC,:);
    Pattern_neu=catpad(2,Pattern_neu,t_pat(:),t_no_pat(:));
end
[Pat_CI,Pat_P]=bootstrap(Pattern_neu,1);
Pat_CI=[Pat_CI(1:2:end,:);Pat_CI(2:2:end,:)];

C = Pat_P(logical(triu(ones(size(Pat_P,1)),1)-triu(ones(size(Pat_P,1)),2)));
Pat_P=C(1:2:end);

N=size(Pattern_neu,2);
[CId]=bootstrap_dif_ratio(Pattern_neu(:,1:2:N),Pattern_neu(:,2:2:N),1);


end
