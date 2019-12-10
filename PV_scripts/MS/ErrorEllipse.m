function a=ErrorEllipse(vec)
    p=0.95;
    s = chi2inv(p,2);
    Sigma=cov(vec(1,:),vec(2,:));
    mu=mean(vec,2);
    
    [V, D] = eig(Sigma * s);

    t = linspace(0, 2 * pi);
    a = (V * sqrt(D)) * [cos(t(:))'; sin(t(:))'];
    a(1,:)=a(1, :) + mu(1);
    a(2,:)=a(2, :) + mu(2);

 