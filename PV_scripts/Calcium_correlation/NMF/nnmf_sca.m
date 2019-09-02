function  [ W,Di,H,F]=     nnmf_sca(X,k,dchoice,achoice,asparse,schoice,maxiter,loop)



% Nonnegative matrix factorization and/or Sparse component analysis.
%
% Usage:
% [ A,D,Bt,X_hat,niter,sse,sse_diff,tot_sparseness,sparseness] = ...
%   nnmf_sca(X,k,dchoice,achoice,asparse,schoice,maxiter)
%
% Inputs:
% X:  m x n data matrix.
% k:  number of factors requested.
% Two choices for the D matrix:
% dchoice:  diag|ident
% Three  choices for the A matrix:
% achoice:  nneg|sparse|both
% asparse:  level of sparseness
% Two choices for sparseness, random or along the long dimension of X:
% schoice:  random|bylong
% maxiter:  maximum number of iterations allowed.
%
% Outputs:
% A,D,Bt
% X_hat:  A*D*Bt
% niter:  total number of iterations used.
% sse:  sum of squared errors
% sse_diff:  difference in sse between final iterations
% sparseness:  sparseness along the long dimension
% tot_sparseness:  total sparseness
% Defaults:
if nargin < 7 maxiter = 1000; end
if nargin < 6 schoice = 'random'; end
if nargin < 5 asparse = 0.9; end
if nargin < 4 achoice = 'sparse'; end
if nargin < 3 dchoice = 'diag'; end
F=inf;
for i=1:loop
    
    
    [m,n] = size(X);
    Transpose = false;
    %if n > m
    %    Transpose = true;
    %    X = X';
    %    [m,n] = size(X);
    %end
    % Sparseness: set the number of zero elements per column.
    nsparse = round(asparse*m);
    if nsparse == 0
        nsparse = ceil(asparse*m);
    end
    % Initialize D matrix
    Di = eye(k);
    
    % Initialize the A matrix and normalize the columns.
    A = rand(m,k);
    for ncols = 1:k
        A(:,ncols) = A(:,ncols)/norm(A(:,ncols));
    end
    sse_diff = 1;
    sse = 1;
    niter = 0;
    small0 = eps^(1/3);
    small = 0;
    % Iteration
    while sse_diff > small0
        if niter > maxiter
            break
        end
        niter = niter + 1;
        % Calculate Bt and implement nonnegativity:
        Bt = pinv(A*Di)*X;
        nan_ind = isnan(Bt);
        inf_ind = isinf(Bt);
        neg_ind = Bt<=0;
        Bt(nan_ind) = small;
        Bt(inf_ind) = small;
        Bt(neg_ind) = small;
        % Normalize the rows.
        for nrows = 1:k
            Bt(nrows,:) = Bt(nrows,:)/norm(Bt(nrows,:));
        end
        % Here we check again for NaN, inf, or negative values before the
        % pseudoinverse calculation.
        nan_ind = isnan(Bt);
        inf_ind = isinf(Bt);
        neg_ind = Bt<=0;
        Bt(nan_ind) = small;
        Bt(inf_ind) = small;
        Bt(neg_ind) = small;
        % Calculate D:
        switch dchoice
            case 'diag'
                Ap = pinv(A);
                Btp = pinv(Bt);
                Di = Ap*X*Btp;
                Di = diag(diag(Di));
                % Check for nonnegativity of the D diagonal
                switch achoice
                    case 'nneg'
                        neg_ind = diag(Di)<=0;
                        Di(neg_ind,neg_ind) = 0;
                        
                    case 'sparse'
                        
                    case 'both'
                        neg_ind = diag(Di)<=0;
                        Di(neg_ind,neg_ind) = 0;
                end
            case 'ident'
                % nothing to do here
        end
        % Calculate A:
        A = X*pinv(Di*Bt);
        switch achoice
            case 'nneg'     % Implement nonnegativity:
                nan_ind = isnan(A);
                inf_ind = isinf(A);
                neg_ind = A<=0;
                
                A(nan_ind) = small;
                A(inf_ind) = small;
                A(neg_ind) = small;
            case 'sparse'   % Implement sparseness:
                
                switch schoice
                    case 'random'
                        [A_sorted] = sort(abs(A(:)),'ascend');
                        cutoff = A_sorted(nsparse*k);
                        sparse_ind = abs(A)<=cutoff;
                        A(sparse_ind) = small;
                    case 'bylong'
                        for kcols = 1:k
                            [A_sorted] = sort(abs(A(:,kcols)),'ascend');
                            cutoff = A_sorted(nsparse);
                            sparse_ind = abs(A(:,kcols))<=cutoff;
                            A(sparse_ind,kcols) = small;
                        end
                end
            case 'both'     % Implement nonnegativity and sparseness:
                nan_ind = isnan(A);
                inf_ind = isinf(A);
                neg_ind = A<=0;
                
                A(inf_ind) = small;
                A(nan_ind) = small;
                A(neg_ind) = small;
                
                switch schoice
                    case 'random'
                        [A_sorted] = sort(abs(A(:)),'ascend');
                        cutoff = A_sorted(nsparse*k);
                        sparse_ind = abs(A)<=cutoff;
                        A(sparse_ind) = small;
                    case 'bylong'
                        for kcols = 1:k
                            [A_sorted] = sort(abs(A(:,kcols)),'ascend');
                            cutoff = A_sorted(nsparse);
                            sparse_ind = abs(A(:,kcols))<=cutoff;
                            A(sparse_ind,kcols) = small;
                        end
                end
        end
        % Normalize A: it provides a more balanced D for the option 'diag' at the
        % expense of a slightly poorer residual.
        switch dchoice
            case 'diag'
                for ncols = 1:k
                    A(:,ncols) = A(:,ncols)/norm(A(:,ncols));
                end
            case 'ident'
        end
        % Calculate residual:
        X_hat = A*Di*Bt;
        R = X - X_hat;
        sse_old = sse;
        sse = R(:)'*R(:) ;
        sse_diff = abs(sse_old - sse);
    end
    % Calculate sparseness:
    % 1. total:
    tot_sparseness = sum(A(:)==small)/(m*k);
    % 2. along the long dimension of X:
    sparseness = zeros(1,k);
    for kcols = 1:k
        sparseness(kcols) = sum(A(:,kcols)==small)/m;
    end
    if Transpose
        A_bk = A;
        A = Bt';
        Bt = A_bk';
        X_hat = X_hat';
    end
if (sse<F) 
    W=A;
    D=Di;
    H=Bt;
    F=sse;
end
end
