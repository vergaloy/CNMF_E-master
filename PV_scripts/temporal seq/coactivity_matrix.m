function Out=coactivity_matrix(M,order)

M=logical(M);
if (order==1)
    cprintf('*blue','Output is equal to Input for order=1!\n')
    Out=M;
else
    %%
    x=[size(M,1),ones(1,order)*size(M,2)'];
    Out=logical(zeros(x));
    S.type = '()';
    S.subs = repmat({':'},1,ndims(Out));
    %intialize waiting bar
    clear textprogressbar
    warning('off','all')
    textprogressbar('Creating coactivity matrix ');
    
    for i=1:size(M,1)
        textprogressbar(i/size(M,1)*100);
        vec=M(i,:)';
        temp=vec;
        for o=2:order
            dimor=fliplr(1:o);
            temp = bsxfun(@times,temp,permute(vec(:),dimor));
        end
        S.subs{1} = i;
        Out=subsasgn(Out,S,temp);
    end
    textprogressbar('done');
end