function W_all=copyW(W_all,W)

for i=1:size(W_all,2)
    t1=W_all{1,i};
    t2=W{1,i};
    t1(size(t1,1)+1:size(t1,1)+size(t2,1),size(t1,2)+1:size(t1,2)+size(t2,2))=t2;
    W_all{1,i}=t1;
end
    