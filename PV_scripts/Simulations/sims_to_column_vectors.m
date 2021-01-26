
no=2.^(-5:1:4);
pat_n=(2:11);
pat_rep=ceil(0.5*exp(0.6.*(1:10)));
rep=10;
k=1;
for i=1:rep %noise
    for j=1:5  %noise pattern number of neurons
        for y=1:rep   %noise pattern reppetition
            for r=1:rep            
            V(k,1)=no(i);
            V(k,2)=pat_n(j);
            V(k,3)=pat_rep(y);
            V(k,4)=C(i,j,y,r);  
            k=k+1;
            end
        end
    end
end