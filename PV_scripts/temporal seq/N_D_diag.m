function Out=N_D_diag(A);

for i=1:size(A,1)
    Out(i)=get_element(A,i);
end
end




function e=get_element(A,v)
S.type = '()';
S.subs = repmat({v},1,ndims(A));
e=subsref(A,S);
end