function separate_rem_active(D,hyp,N,sf,bin);



hypno=bin_data(hyp,sf,bin);
[REM,WAKE,NREM]=separate_D_into_sleep(D{1,4},hypno,N);
B={D{1,1},D{1,2},D{1,3},REM,WAKE,NREM,D{1,5}};
A=Get_significan_active(B);
% CI=get_overlap_above_chance(A(:,3).*A(:,4),s(:,1),3)
end

function [REM,WAKE,NREM]=separate_D_into_sleep(S,hypno,N);

REM=[];
NREM=[];
WAKE=[];

for i=1:size(N,1)
    temp=S(i,:);
    temp_rem=temp(hypno(N(i),:)==1);
    temp_nrem=temp(hypno(N(i),:)==0.5);
    temp_wake=temp(hypno(N(i),:)==0);
    
    REM=catpad(1,REM,temp_rem);
    NREM=catpad(1,NREM,temp_nrem);
    WAKE=catpad(1,WAKE,temp_wake);
end
end

function A=Get_significan_active(B)

for i=1:size(B,2)
    data=B{1,i};
    active=data;
    active(active>0)=1;
    active=1-nanmean(active,2);
    len=nansum(~isnan(data),2);
    active=active.^len;
    A(:,i)=double(active<0.05);
end
end