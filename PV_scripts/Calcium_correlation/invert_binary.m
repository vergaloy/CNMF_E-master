function B=invert_binary(C);
Bmatinv = inv(C)
n=size(A,1);
B=eye(n);
for p=1:n
    vec=[(1:p-1) n (p:n-1)];
    test=1;
    while A(p,p)==0
        if test==n
            error('Matrix is not inversible')
        end
        A=A(vec,:);
        B=B(vec,:);
        test=test+1;
    end
    B(p,:)=B(p,:)& A(p,p);
    A(p,:)=A(p,:)& A(p,p);
    for q=p+1:n
        B(q,:) = xor(B(q,:) , A(q,p)& B(p,:));
        A(q,:) = xor(A(q,:) , A(q,p)& A(p,:));
    end
end
for p=n:-1:2
    for q=p-1:-1:1
        B(q,:) = xor(B(q,:) , A(q,p)& B(p,:));
        A(q,:) = xor(A(q,:) , A(q,p)& A(p,:));
    end
end
% show the results to compare with inv function
B