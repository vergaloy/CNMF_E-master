function [CI,P]=get_CI_and_P_sim_data(X,c)
% [CI,P]=get_CI_and_P_sim_data([LCRA.early.fast.N;LCRA.late.fast.N]',2);
% [CI,P]=get_CI_and_P_sim_data([LCRA.early.fast.G;LCRA.late.fast.G;LCRA.early.slow.G;LCRA.late.slow.G]',3);
% [CI,P]=get_CI_and_P_sim_data([SCR.early.fast.G;SCR.late.fast.G;SCR.early.slow.G;SCR.late.slow.G]',3);
% [CI,P]=get_CI_and_P_sim_data([CN21.early.fast.G;CN21.late.fast.G;CN21.early.slow.G;CN21.late.slow.G]',3);

% [CI,P]=get_CI_and_P_sim_data([LCRA.early.fast.N;LCRA.late.fast.N;LCRA.early.slow.N;LCRA.late.slow.N]',3);



if ~exist('c','var')
    c=(size(X,2)^2-size(X,2))/2;
end

P=get_P(X,c);
CI=get_CI(X,1);

end
function P=get_P(X,c)

alpha=5/c/2;
col=size(X,2);

if (size(X,2)>1)
    b=nchoosek(1:col,2);
    P=zeros(col);
    comp=size(b,1);
    for i=1:comp
        t1=X(:,b(i,1));
        t2=X(:,b(i,2));
        P(b(i,1),b(i,2))=(prctile(t1-t2,alpha)*prctile(t1-t2,100-alpha))>0;
    end
    P=P+P';
end
end

function CI=get_CI(X,c)
alpha=5/c/2;
for i=1:size(X,2)
    CI(i,:)=[mean(X(:,i)),prctile(X(:,i),100-alpha),prctile(X(:,i),alpha)];
end
    
end