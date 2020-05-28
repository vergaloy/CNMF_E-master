function MS_vs_random(y)
% MS_vs_random(k);

close all
warning off
OMS=   acos(MSget(y))./pi;                 %single_pattern_MS(zscore(y,[ ],1),0);  %

for s=1:1000
    rsample=randomize(y);
    rsample=acos(MSget(y))./pi ;  %single_pattern_MS(zscore(rsample,[ ],1),0); %-mean(rsample,1)
    MS(s,:,:)=rsample;
    Z = linkage(squareform(rsample),'ward');
    Zr(:,s)=Z(:,3);
end
Zr=Zr(:);
CIlo=squeeze(mean(MS,1)-3*std(MS,[],1));
CIup=squeeze(mean(MS,1)+3*std(MS,[],1));
S=OMS;
S(S>CIlo&S<CIup)=nan;

try
    if (size(y,2)==9)
        values = {'HC','PreS','PostS','REM','HT','LT','NREM','A','C'};
    end
    if (size(y,2)==5)
        values = {'HC','PreS','PostS','A','C'};
    end
        if (size(y,2)==8)
        values = {'PreS','PostS','REM','HT','LT','NREM','A','C'};
    end
    
    
    ax=heatmap(values,values,S);
    axp = struct(ax);       %you will get a warning
    axp.Axes.XAxisLocation = 'top';
    figure
    Z = linkage(squareform(OMS),'ward');
    dendrogram(Z,'ColorThreshold',prctile(Zr,5),'Labels', values)
    yline(prctile(Zr,5),'--')
catch
    
    figure
    Z = linkage(squareform(OMS),'ward');
    dendrogram(Z,'ColorThreshold',prctile(Zr,5))
end

end



function out=randomize(A)
for i=1:size(A,2)
    X=A(:,i);
    out(:,i)=X(randperm(length(X)));
end
end


function MS=MSget(A)
b=nchoosek(1:size(A,2),2);
MS=zeros(size(A,2));
for i=1:size(b,1)
    v1=A(:,b(i,1));
    v2=A(:,b(i,2));
MS(b(i,1),b(i,2))=nanmean(dot(v1,v2)./(sqrt(sum((v1).^2,1)).*sqrt(sum((v2).^2,1))));
end
MS=MS+MS'+diag(ones(1,size(A,2)));

end
