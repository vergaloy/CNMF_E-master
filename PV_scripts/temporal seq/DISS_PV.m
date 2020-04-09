function diss = DISS_PV(H1,W1,H2,W2)
% ------------------------------------------------------------------------
% USAGE:  
% ------------------------------------------------------------------------
% INPUTS
% H1 and W1 are the output of a convNMF fit with K factors
% H2 and W2 are the output of a different convNMF with the same K.
% ------------------------------------------------------------------------
% OUTPUTS
% diss:     Diss is a measure of the disssimilarity of two factorizations.
% ------------------------------------------------------------------------
% Emily Mackevicius and Andrew Bahle
% adapted from Wu et al 2016

    K1 = size(W1,2);
    K2 = size(W2,2);
    
    for i = 1:K1
        for j = 1:K2
        Xhat1 = helper.reconstruct(W1(:,i,:),H1(i,:));
        Xhat2 = helper.reconstruct(W2(:,j,:),H2(j,:));
        C(i,j) = dot_norm(Xhat1(:),Xhat2(:));
        end
    end
    maxrow = max(C,[],1); 
    maxcol = max(C,[],2); 
    maxrow(isnan(maxrow)) = 0;
    maxcol(isnan(maxcol)) = 0;
    diss = 1/(K1+K2)*((K1+K2) - sum(maxrow) -sum(maxcol)); 

end

function out=dot_norm(t1,t2)
out=dot(t1,t2)/(norm(t1)*norm(t2)+eps);
end

