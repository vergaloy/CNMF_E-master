function [MS,pat_MS,weig] = W_SM(W1,W2)
% ------------------------------------------------------------------------
% USAGE:  
% ------------------------------------------------------------------------
% INPUTS
%    W1 and W2 are output of NNMF, 
% ------------------------------------------------------------------------
% OUTPUTS
% MS:  the average similarity ponderated by the number
%     of active cells in each pattern, ie patterns with more cells have more
%     weight
% ------------------------------------------------------------------------


    K1 = size(W1,2);
    K2 = size(W2,2);
    [w1,w2]=get_W_weight(W1,W2);
    for i = 1:K1
        for j = 1:K2
        Xhat1 = W1(:,i,:);
        Xhat2 = W2(:,j,:);
        C(i,j) = dot_norm(Xhat1(:),Xhat2(:));
        end
    end
    maxrow = max(C,[],1); 
    maxcol = max(C,[],2); 
    t=sum([w1,w2]);
    MS=sum([(maxcol.*(w1/t)')',maxrow.*(w2/t)]);
    pat_MS=[maxcol',maxrow];
    weig=[w1,w2];
end

function out=dot_norm(t1,t2)
out=dot(t1,t2)/(norm(t1)*norm(t2)+eps);
end


function [w1,w2]=get_W_weight(W1,W2);
W1=W1./max(W1,2);
w1=(W1>0.01);
w1=sum(w1,1);
W2=W2./max(W2,2);
w2=(W2>0.01);
w2=sum(w2,1);
end