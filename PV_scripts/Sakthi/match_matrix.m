function F=match_matrix(A,B);


F=F_norm(A,B);
  b = nchoosek(1:size(A,2),2);
  stop=0;
while(stop==0)
    for j=1:size(b,1)
        Bs=B;
        Bs(:,[b(j,1) b(j,2)]) = Bs(:,[b(j,2) b(j,1)]);
        Fs=F_norm(A,Bs);
        if(Fs<F)
            break
        end
        if(j==size(b,1))
            stop=1;
        end
    end
    B=Bs;
    F=Fs;
end

end
function F=F_norm(A,B)
F=sqrt(trace((A-B)*(A-B)'));
end