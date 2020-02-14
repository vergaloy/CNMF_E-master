function [W,H]=Get_connectivity(obj)
%Get_connectivity(C2);
min_pat=5;
%NumberOfAssemblies= get_patterns(obj);
NumberOfAssemblies=5;
if (NumberOfAssemblies~=0)
    [~,W,~,~]=NMF(obj,NumberOfAssemblies,3);
else
    W=zeros(size(obj,1),1);
end

if (isempty(W))
    H=zeros(1,size(obj,2));
else
    H=get_H(obj,W,min_pat);
end

kill_inactive=logical(sum(H,2)==0);
H(kill_inactive,:)=[];
W(:,kill_inactive)=[];

pat_cells=plot_W_connectivity(W);
plot_W_activity(obj,W,H);


dummy=1;