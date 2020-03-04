function [F]=match_matrix(A,B,getMS)


if(isempty(A)||isempty(B))
    F=0;
    return
end



A=A./max(A,[],1);  %normalize to 0-1;
B=B./max(B,[],1);  %normalize to 0-1;
A(isnan(A))=0;
B(isnan(B))=0;

if(size(A,2)<size(B,2))
    d=size(B,2)-size(A,2);
    A=[A,zeros(size(A,1),d)];
end

if(size(B,2)<size(A,2))
    d=size(A,2)-size(B,2);
    B=[B,zeros(size(B,1),d)];
end

overlap=sum(A,1).*sum(B,1);
overlap=(overlap~=0);
F=F_norm(A(:,overlap),B(:,overlap));

b = nchoosek(1:size(A,2),2);
stop=0;
while(stop==0)
    for j=1:size(b,1)
        Bs=B;
        Bs(:,[b(j,1) b(j,2)]) = Bs(:,[b(j,2) b(j,1)]);
        
        overlap=sum(A,1).*sum(Bs,1);
        overlap=(overlap~=0);
        Fs=F_norm(A(:,overlap),Bs(:,overlap));
        
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

overlap=sum(A,1).*sum(B,1);
overlap=(overlap~=0);

F=F_norm(A(:,overlap),B(:,overlap));
if(getMS==1)
    F=get_MS(A(:,overlap),B(:,overlap));
end

end
function F=F_norm(A,B)
F=sqrt(trace((A-B)*(A-B)'));
end

function F=norm_dot(A,B)
for i=1:size(A,2)
    v1=A(:,i);
    v2=B(:,i);
    MS(i)=nanmean(dot(v1,v2)./(sqrt(sum((v1).^2,1)).*sqrt(sum((v2).^2,1))));
end
F=nanmean(MS);
end

