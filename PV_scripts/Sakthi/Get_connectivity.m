function [W,H,E]=Get_connectivity(obj)
min_pat=3;


    [W,H,~,E]=NMF_Akaike(obj);

if (isempty(W))
    H=zeros(1,size(obj,2));
else
    %H=get_H(obj,W,min_pat);
end

% kill_inactive=logical(sum(H,2)==0);
% H(kill_inactive,:)=[];
% W(:,kill_inactive)=[];
% 
% pat_cells=plot_W_connectivity(W);
% plot_W_activity(obj,W,H);

