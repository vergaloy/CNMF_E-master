function H=update_H(X,W)

K=size(W,2);
T=size(X,2);
L=size(W,3);

    WTX = zeros(K, T);
    WTXhat = zeros(K, T);
    for l = 1 : L
        X_shifted = circshift(X,[0,-l+1]); 
        Xhat_shifted = circshift(Xhat,[0,-l+1]); 
        WTX = WTX + W(:, :, l)' * X_shifted;
        WTXhat = WTXhat + W(:, :, l)' * Xhat_shifted;
    end   
         
    % Compute regularization terms for H update
    if params.lambda>0
        dRdH = params.lambda.*(~eye(K))*conv2(WTX, smoothkernel, 'same');  
    else 
        dRdH = 0; 
    end
    if params.lambdaOrthoH>0
        dHHdH = params.lambdaOrthoH*(~eye(K))*conv2(H, smoothkernel, 'same');
    else
        dHHdH = 0;
    end
    dRdH = dRdH + params.lambdaL1H + dHHdH; % include L1 sparsity, if specified
    
    % Update H
    H = H .* WTX ./ (WTXhat + dRdH +eps);
        