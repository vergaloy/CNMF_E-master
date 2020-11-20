function D2=get_distance_patterns(ZI,ZJ,Wall)

% D2=get_distance_patterns(t(:,1)',t(:,2:end)',Wall);
m0=max_divisor(ZI);
m=max_divisor(ZJ);
ZI=ZI./m0;
ZJ=ZJ./m';
for i=1:size(ZJ,1)
    w1=Wall{m0};
    w2=Wall{m(i)};
    w1=w1(ZI',:);
    w2=w2(ZJ(i,:)',:);
    % complete with 0s
    w=catpad(1,w1,w2);
    w(isnan(w))=0;
    w1=w(1:size(w1,1),:);
    w2=w(size(w1,1)+1:size(w,1),:);
    D = pdist2(w1',w2','cosine');
    D(isnan(D))=1;
    M = matchpairs(D,10000);
    w1=w1(:,M(:,1));
    w2=w2(:,M(:,2));
    D2(i)=1-get_cosine(w1(:),w2(:));
end
end

function m=max_divisor(V)
m=zeros(1,size(V,1));
for i=1:size(V,1)
    f=V(i,:);
    d = f(1);
    for n = 2:numel(f)
        d = gcd(d,f(n));
    end
    m(i)=d;
end
end

