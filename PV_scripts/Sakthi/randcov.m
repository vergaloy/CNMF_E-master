function C = randcov(n,density,sd)


A=random('HalfNormal',0,sd,n,n);
R = random('Binomial',1,density,n,n);
A=A.*R;

C = A + (sd).*speye(n);
C=C*C';
end