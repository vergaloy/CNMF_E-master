function Out=SubscritRef(v,A)

S.type = '()';
S.subs = repmat({':'},1,ndims(A));
S.subs(1) = {v};

Out=subsref(A,S);