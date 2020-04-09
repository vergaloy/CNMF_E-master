function get_pattern_activity(Y,H,le)

le=[0 le];
for i=1:size(le,2)-1
    D=H(:,le(i)+1:le(i+1));
    A=Y(:,le(i)+1:le(i+1));
    hm(:,i)=mean(D,2);
    m(i)=mean(A,'all');
    
    
end

hm
hm./m
