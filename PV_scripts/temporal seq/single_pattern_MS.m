function MS=single_pattern_MS(Y,frob);

dim=size(Y,2);
b=nchoosek(1:dim,2);
MS=zeros(dim,dim);
for i=1:size(b,1)
    id1=b(i,1);
    id2=b(i,2);
    t1=double(Y(:,id1));
    t2=double(Y(:,id2));
    if (frob)
        MS(id1,id2)=frob_norm(t1,t2);
    else
        MS(id1,id2)=dot_norm(t1,t2);
    end
end
if (frob)
MS=(MS+MS');    
else
MS=(MS+MS')+diag(ones(1,dim));
MS=acos(MS)/pi;
end

end

function out=dot_norm(t1,t2)
out=dot(t1,t2)/(norm(t1)*norm(t2)+eps);
end

function out=frob_norm(t1,t2)
t1=t1-mean(t1);
t2=t2-mean(t2);
A=t1-t2;
out=sqrt(trace(A*A'));
end